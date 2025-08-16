import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zonix/ads/ad_helper.dart';

class AdService {
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;
  static DateTime? _lastShownAt;
  static int _loadAttempts = 0;
  static int _rewardedLoadAttempts = 0;
  static const int _maxFailedLoadAttempts = 3;
  static const Duration _minIntervalBetweenAds = Duration(minutes: 2);
  // static const Duration _retryDelay = Duration(seconds: 5);

  // Ad loading state
  static bool _isLoadingInterstitial = false;
  static bool _isLoadingRewarded = false;

  // Error tracking
  static final List<String> _adErrors = [];
  static const int _maxErrorsToTrack = 10;

  // WebView status
  static bool _webViewAvailable = true;
  static bool _adsEnabled = true;

  // AdMob configuration
  static const List<String> _testDeviceIds = [
    'F0EBCC0D094AE7B19D57B24745DF7290', // Your test device
    '192.168.0.102:5555', // Your current device
    'EMULATOR', // For emulator testing
  ];

  // Initialize ads with AdMob best practices
  static Future<void> initialize() async {
    try {
      // Initialize MobileAds with proper configuration
      await MobileAds.instance.initialize();

      // Configure test devices for development
      if (kDebugMode) {
        await MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(
            testDeviceIds: _testDeviceIds,
            tagForChildDirectedTreatment:
                TagForChildDirectedTreatment.unspecified,
            tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
            maxAdContentRating: MaxAdContentRating.pg,
          ),
        );

        print('✅ AdMob configured for TEST mode');
      }

      // Try to preload ads with error handling
      _tryPreloadAds();
    } catch (e) {
      _logError('Failed to initialize MobileAds: $e');
      _adsEnabled = false;
    }
  }

  // Try to preload ads with error handling
  static void _tryPreloadAds() {
    if (!_adsEnabled) return;

    try {
      // Add delay to ensure MobileAds is fully initialized
      Timer(const Duration(seconds: 2), () {
        preloadInterstitial();
        preloadRewarded();
        if (kDebugMode) {
          print('✅ Ads preloading started');
        }
      });
    } catch (e) {
      _logError('Failed to start ad preloading: $e');
      _adsEnabled = false;
    }
  }

  // Check if ads can be loaded
  static bool get canLoadAds => _adsEnabled && _webViewAvailable;

  // Interstitial Ads with AdMob best practices
  static void preloadInterstitial() {
    if (_interstitialAd != null || _isLoadingInterstitial || !_adsEnabled) {
      return;
    }

    _isLoadingInterstitial = true;

    // Create ad request with proper targeting
    const adRequest = AdRequest(
      keywords: ['pets', 'animals', 'care'],
      contentUrl: 'https://example.com',
      nonPersonalizedAds: false,
    );

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loadAttempts = 0;
          _interstitialAd = ad;
          _isLoadingInterstitial = false;
          if (kDebugMode) {
            print('✅ Interstitial ad loaded successfully');
          }
        },
        onAdFailedToLoad: (error) {
          _loadAttempts++;
          _interstitialAd = null;
          _isLoadingInterstitial = false;

          // Check if it's a WebView/JavascriptEngine error
          if (error.message.contains('JavascriptEngine') == true) {
            _webViewAvailable = false;
            _logError('WebView not available, disabling ads');
            return;
          }

          // Log specific AdMob error codes
          _logError(
              'Interstitial ad failed to load: ${error.message} (Code: ${error.code})');

          // Implement exponential backoff for retries
          if (_loadAttempts <= _maxFailedLoadAttempts) {
            final retryInMs = pow(2, _loadAttempts) * 1000;
            Timer(Duration(milliseconds: retryInMs.toInt()), () {
              if (_webViewAvailable && _adsEnabled) {
                preloadInterstitial();
              }
            });
          }
        },
      ),
    );
  }

  static bool isInterstitialAdLoaded() => _interstitialAd != null;

  static void showInterstitialIfAvailable() {
    if (!isInterstitialAdLoaded()) {
      preloadInterstitial();
      return;
    }

    // Check if enough time has passed since last ad
    if (_lastShownAt != null &&
        DateTime.now().difference(_lastShownAt!) < _minIntervalBetweenAds) {
      if (kDebugMode) {
        print('⏰ Ad shown too recently, skipping');
      }
      return;
    }

    final ad = _interstitialAd;
    if (ad == null) return;

    // Set up proper ad callbacks
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _lastShownAt = DateTime.now();
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitial();
        if (kDebugMode) {
          print('✅ Interstitial ad dismissed');
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _logError('Interstitial ad failed to show: ${error.message}');
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitial();
      },
      onAdShowedFullScreenContent: (ad) {
        if (kDebugMode) {
          print('🎬 Interstitial ad showed');
        }
      },
      onAdImpression: (ad) {
        if (kDebugMode) {
          print('📊 Interstitial ad impression recorded');
        }
      },
    );

    ad.show();
    _interstitialAd = null;
  }

  // Rewarded Ads with AdMob best practices
  static void preloadRewarded() {
    if (_rewardedAd != null || _isLoadingRewarded || !_adsEnabled) return;

    _isLoadingRewarded = true;

    // Create ad request with proper targeting
    const adRequest = AdRequest(
      keywords: ['pets', 'animals', 'care'],
      contentUrl: 'https://example.com',
      nonPersonalizedAds: false,
    );

    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedLoadAttempts = 0;
          _rewardedAd = ad;
          _isLoadingRewarded = false;
          if (kDebugMode) {
            print('✅ Rewarded ad loaded successfully');
          }
        },
        onAdFailedToLoad: (error) {
          _rewardedLoadAttempts++;
          _rewardedAd = null;
          _isLoadingRewarded = false;

          // Check if it's a WebView/JavascriptEngine error
          if (error.message.contains('JavascriptEngine') == true) {
            _webViewAvailable = false;
            _logError('WebView not available, disabling ads');
            return;
          }

          // Log specific AdMob error codes
          _logError(
              'Rewarded ad failed to load: ${error.message} (Code: ${error.code})');

          // Implement exponential backoff for retries
          if (_rewardedLoadAttempts <= _maxFailedLoadAttempts) {
            final retryInMs = pow(2, _rewardedLoadAttempts) * 1000;
            Timer(Duration(milliseconds: retryInMs.toInt()), () {
              if (_webViewAvailable && _adsEnabled) {
                preloadRewarded();
              }
            });
          }
        },
      ),
    );
  }

  static bool isRewardedAdLoaded() => _rewardedAd != null;

  static Future<bool> showRewardedIfAvailable({
    required void Function(AdWithoutView, RewardItem) onUserEarnedReward,
  }) async {
    final ad = _rewardedAd;
    if (ad == null) {
      preloadRewarded();
      return false;
    }

    // Set up proper ad callbacks
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        preloadRewarded();
        if (kDebugMode) {
          print('✅ Rewarded ad dismissed');
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _logError('Rewarded ad failed to show: ${error.message}');
        ad.dispose();
        _rewardedAd = null;
        preloadRewarded();
      },
      onAdShowedFullScreenContent: (ad) {
        if (kDebugMode) {
          print('🎬 Rewarded ad showed');
        }
      },
      onAdImpression: (ad) {
        if (kDebugMode) {
          print('📊 Rewarded ad impression recorded');
        }
      },
    );

    try {
      await ad.show(onUserEarnedReward: onUserEarnedReward);
      _rewardedAd = null;
      return true;
    } catch (e) {
      _logError('Error showing rewarded ad: $e');
      return false;
    }
  }

  // Error logging and tracking
  static void _logError(String error) {
    _adErrors.add('${DateTime.now()}: $error');
    if (_adErrors.length > _maxErrorsToTrack) {
      _adErrors.removeAt(0);
    }
    if (kDebugMode) {
      print('❌ Ad Error: $error');
    }
  }

  // Get error history
  static List<String> getErrorHistory() => List.unmodifiable(_adErrors);

  // Clear error history
  static void clearErrorHistory() => _adErrors.clear();

  // Dispose all ads
  static void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
  }

  // Force reload all ads
  static void forceReload() {
    dispose();
    _loadAttempts = 0;
    _rewardedLoadAttempts = 0;
    _webViewAvailable = true; // Reset WebView status
    preloadInterstitial();
    preloadRewarded();
  }

  // Get current ad status
  static Map<String, dynamic> getAdStatus() {
    return {
      'adsEnabled': _adsEnabled,
      'webViewAvailable': _webViewAvailable,
      'interstitialLoaded': _interstitialAd != null,
      'rewardedLoaded': _rewardedAd != null,
      'errorCount': _adErrors.length,
      'lastError': _adErrors.isNotEmpty ? _adErrors.last : null,
    };
  }
}
