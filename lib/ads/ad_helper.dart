// Provides Ad Unit IDs per platform. Replace with your real AdMob IDs for production.
import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        // TEST Banner ID for Android (development mode)
        return 'ca-app-pub-3940256099942544/9214589741';
      } else {
        // REAL Banner ID for Android (production mode)
        return 'ca-app-pub-2202944286085621/9527269483';
      }
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        // TEST Banner ID for iOS (development mode)
        return 'ca-app-pub-3940256099942544/9214589741';
      } else {
        // REAL Banner ID for iOS (production mode)
        return 'ca-app-pub-2202944286085621/9527269483';
      }
    } else {
      throw UnsupportedError('Unsupported platform for AdMob');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        // TEST Interstitial ID for Android (development mode)
        return 'ca-app-pub-3940256099942544/1033173712';
      } else {
        // REAL Interstitial ID for Android (production mode)
        return 'ca-app-pub-2202944286085621/4274942809';
      }
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        // TEST Interstitial ID for iOS (development mode)
        return 'ca-app-pub-3940256099942544/1033173712';
      } else {
        // REAL Interstitial ID for iOS (production mode)
        return 'ca-app-pub-2202944286085621/4274942809';
      }
    } else {
      throw UnsupportedError('Unsupported platform for AdMob');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        // TEST Rewarded ID for Android (development mode)
        return 'ca-app-pub-3940256099942544/5224354917';
      } else {
        // REAL Rewarded ID for Android (production mode)
        return 'ca-app-pub-2202944286085621/7479690648';
      }
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        // TEST Rewarded ID for iOS (development mode)
        return 'ca-app-pub-3940256099942544/5224354917';
      } else {
        // REAL Rewarded ID for iOS (production mode)
        return 'ca-app-pub-2202944286085621/7479690648';
      }
    } else {
      throw UnsupportedError('Unsupported platform for AdMob');
    }
  }
}
