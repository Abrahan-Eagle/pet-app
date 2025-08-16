import 'package:flutter/foundation.dart';

class PerformanceConfig {
  // Debug mode optimizations
  static const bool enableDebugOptimizations = kDebugMode;

  // Frame rate optimizations
  static const int targetFrameRate = 60;
  static const Duration frameTimeout = Duration(milliseconds: 16); // 60 FPS

  // Memory optimizations
  static const int maxImageCacheSize = 100; // MB
  static const int maxImageCacheObjects = 1000;

  // Animation optimizations
  static const bool enableAnimationOptimizations = true;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // List optimizations
  static const int listItemCacheExtent = 100;
  static const bool enableListOptimizations = true;

  // Image optimizations
  static const bool enableImageOptimizations = true;
  static const double imageQuality = 0.8;

  // Ad performance
  static const Duration adRetryDelay = Duration(seconds: 10);
  static const int maxAdRetries = 3;
  static const Duration adLoadTimeout = Duration(seconds: 30);

  // Network optimizations
  static const Duration networkTimeout = Duration(seconds: 15);
  static const int maxConcurrentRequests = 3;

  // Cache optimizations
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 50; // MB

  // Debug logging
  static void logPerformance(String message) {
    if (kDebugMode) {
      print('🚀 Performance: $message');
    }
  }

  static void logWarning(String message) {
    if (kDebugMode) {
      print('⚠️ Performance Warning: $message');
    }
  }

  static void logError(String message) {
    if (kDebugMode) {
      print('❌ Performance Error: $message');
    }
  }
}
