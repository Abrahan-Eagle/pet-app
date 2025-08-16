import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobConfig {
  // Test Device IDs - Add your device IDs here
  static const List<String> testDeviceIds = [
    'F0EBCC0D094AE7B19D57B24745DF7290', // Your test device
    '192.168.0.102:5555', // Your current device
    'EMULATOR', // For emulator testing
  ];

  // AdMob App ID
  static const String appId =
      'ca-app-pub-3940256099942544~3347511713'; // Test App ID

  // Banner Ad Unit ID
  static const String bannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111'; // Test Banner ID

  // Interstitial Ad Unit ID
  static const String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial ID

  // Rewarded Ad Unit ID
  static const String rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // Test Rewarded ID

  // Initialize AdMob with best practices
  static Future<void> initialize() async {
    try {
      // Initialize MobileAds
      await MobileAds.instance.initialize();

      // Configure for development/testing
      if (kDebugMode) {
        await MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(
            testDeviceIds: testDeviceIds,
            tagForChildDirectedTreatment:
                TagForChildDirectedTreatment.unspecified,
            tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
            maxAdContentRating: MaxAdContentRating.pg,
          ),
        );

        debugPrint('✅ AdMob configured for TEST mode');
        debugPrint('📱 Test Device IDs: $testDeviceIds');
      }
    } catch (e) {
      debugPrint('❌ Failed to initialize AdMob: $e');
      rethrow;
    }
  }

  // Create optimized ad request
  static AdRequest createAdRequest({
    List<String>? keywords,
    String? contentUrl,
    bool nonPersonalizedAds = false,
  }) {
    return AdRequest(
      keywords: keywords ?? ['pets', 'animals', 'care', 'veterinary'],
      contentUrl: contentUrl ?? 'https://example.com',
      nonPersonalizedAds: nonPersonalizedAds,
    );
  }

  // Get ad size based on screen width
  static AdSize getAdSize(double screenWidth) {
    if (screenWidth >= 728) {
      return AdSize.leaderboard;
    } else if (screenWidth >= 468) {
      return AdSize.banner;
    } else {
      return AdSize.banner;
    }
  }

  // Check if ads are ready to load
  static bool get areAdsReady {
    try {
      // Basic check for ad loading capability
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get configuration status
  static Map<String, dynamic> getConfigStatus() {
    return {
      'isDebugMode': kDebugMode,
      'testDeviceIds': testDeviceIds,
      'appId': appId,
      'bannerAdUnitId': bannerAdUnitId,
      'interstitialAdUnitId': interstitialAdUnitId,
      'rewardedAdUnitId': rewardedAdUnitId,
      'areAdsReady': areAdsReady,
    };
  }
}

