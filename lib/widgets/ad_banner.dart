import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zonix/ads/ad_helper.dart';

class AdBanner extends StatefulWidget {
  final double? height;
  final EdgeInsets? margin;
  final bool showFallback;
  final AdSize adSize;

  const AdBanner({
    super.key,
    this.height,
    this.margin,
    this.showFallback = true,
    this.adSize = AdSize.banner,
  });

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadAttempts = 0;
  static const int _maxLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (_loadAttempts >= _maxLoadAttempts) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Max load attempts reached';
      });
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: widget.adSize,
      request: _createAdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
            _hasError = false;
            _loadAttempts = 0;
          });
          if (mounted) {
            debugPrint('✅ Banner ad loaded successfully');
          }
        },
        onAdFailedToLoad: (ad, error) {
          // Get error message once
          final message = error.message;
          
          setState(() {
            _hasError = true;
            _errorMessage = message;
            _isLoaded = false;
            _loadAttempts++;
          });
          ad.dispose();

          if (mounted) {
            // Check if it's a WebView/JavascriptEngine error
            if (message.contains('JavascriptEngine')) {
              debugPrint('❌ WebView not available, ads disabled');
            } else {
              debugPrint(
                  '❌ Banner ad failed to load: $message (Code: ${error.code})');
            }
          }

          // Only retry if it's not a WebView error and under max attempts
          if (!message.contains('JavascriptEngine') &&
              _loadAttempts < _maxLoadAttempts) {
            final retryDelay = Duration(seconds: pow(2, _loadAttempts).toInt());
            Future.delayed(retryDelay, () {
              if (mounted && !_isLoaded) {
                _loadAd();
              }
            });
          }
        },
        onAdOpened: (ad) {
          debugPrint('🎬 Banner ad opened');
        },
        onAdClosed: (ad) {
          debugPrint('✅ Banner ad closed');
        },
        onAdImpression: (ad) {
          debugPrint('📊 Banner ad impression recorded');
        },
      ),
    );

    try {
      _bannerAd!.load();
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _loadAttempts++;
      });
      debugPrint('❌ Error loading banner ad: $e');

      // Retry on error
      if (_loadAttempts < _maxLoadAttempts) {
        final retryDelay = Duration(seconds: pow(2, _loadAttempts).toInt());
        Future.delayed(retryDelay, () {
          if (mounted && !_isLoaded) {
            _loadAd();
          }
        });
      }
    }
  }

  // Create proper ad request following AdMob best practices
  AdRequest _createAdRequest() {
    return const AdRequest(
      keywords: ['pets', 'animals', 'care', 'veterinary'],
      contentUrl: 'https://example.com',
      nonPersonalizedAds: false,
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && !widget.showFallback) {
      return const SizedBox.shrink();
    }

    if (_hasError && widget.showFallback) {
      // Check if it's a WebView error
      final isWebViewError = _errorMessage.contains('JavascriptEngine');
      final isMaxAttempts = _errorMessage.contains('Max load attempts');

      return Container(
        height: widget.height ?? 50,
        margin: widget.margin ?? const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isWebViewError
              ? Colors.orange[100]
              : isMaxAttempts
                  ? Colors.red[100]
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isWebViewError
                ? Colors.orange[300]!
                : isMaxAttempts
                    ? Colors.red[300]!
                    : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isWebViewError
                    ? Icons.warning_amber_outlined
                    : isMaxAttempts
                        ? Icons.error_outline
                        : Icons.info_outline,
                color: isWebViewError
                    ? Colors.orange[600]
                    : isMaxAttempts
                        ? Colors.red[600]
                        : Colors.grey[600],
                size: 16,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  isWebViewError
                      ? 'Ads temporarily disabled'
                      : isMaxAttempts
                          ? 'Ad loading failed'
                          : 'Ad temporarily unavailable',
                  style: TextStyle(
                    color: isWebViewError
                        ? Colors.orange[600]
                        : isMaxAttempts
                            ? Colors.red[600]
                            : Colors.grey[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isLoaded) {
      return Container(
        height: widget.height ?? 50,
        margin: widget.margin ?? const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Loading ad...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: widget.height,
      margin: widget.margin,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
