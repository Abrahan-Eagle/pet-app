import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zonix/config/performance_config.dart';
import 'package:zonix/config/admob_config.dart';
import 'package:zonix/providers/pet_provider.dart';
import 'package:zonix/screens/dashboard_screen.dart';
import 'package:zonix/services/ad_service.dart';
import 'package:zonix/services/storage_service.dart';
import 'package:zonix/widgets/onboarding_screen.dart';

// Define a flag to toggle between test and production mode
const bool isTestMode = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Performance optimizations
  if (PerformanceConfig.enableDebugOptimizations) {
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Optimize image cache
    PaintingBinding.instance.imageCache.maximumSize =
        PerformanceConfig.maxImageCacheObjects;
    PaintingBinding.instance.imageCache.maximumSizeBytes =
        PerformanceConfig.maxImageCacheSize * 1024 * 1024;

    PerformanceConfig.logPerformance('Image cache optimized');
  }

  // Initialize AdMob with best practices
  try {
    await AdMobConfig.initialize();

    // Initialize our custom ad service after AdMob is ready
    await AdService.initialize();

    if (isTestMode) {
      PerformanceConfig.logPerformance(
          'AdMob and AdService initialized successfully');
    }
  } catch (e) {
    PerformanceConfig.logError('Error initializing ads: $e');
    // Continue app execution even if ads fail
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PetProvider(),
      child: MaterialApp(
        title: 'Ficha Pet',
        debugShowCheckedModeBanner: false,
        // Performance optimizations
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Reduce unnecessary rebuilds
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
          // Performance optimizations
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
        },
      ),
    );
  }
}

class BannerAdWidget extends StatelessWidget {
  final BannerAd bannerAd;

  BannerAdWidget({super.key})
      : bannerAd = BannerAd(
          adUnitId: AdMobConfig.bannerAdUnitId,
          size: AdSize.banner,
          request: AdMobConfig.createAdRequest(),
          listener: BannerAdListener(
            onAdLoaded: (ad) => debugPrint('✅ Banner ad loaded.'),
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
              debugPrint(
                  '❌ Banner ad failed to load: ${error.message} (Code: ${error.code})');
            },
            onAdOpened: (ad) => debugPrint('🎬 Banner ad opened'),
            onAdImpression: (ad) => debugPrint('📊 Banner ad impression'),
          ),
        )..load();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      child: AdWidget(ad: bannerAd),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    try {
      final isOnboardingComplete = await StorageService.isOnboardingComplete();

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          isOnboardingComplete ? '/dashboard' : '/onboarding',
        );
      }
    } catch (e, stackTrace) {
      logger.e('Error checking onboarding status',
          error: e, stackTrace: stackTrace);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pets,
                size: 80,
                color: Colors.indigo,
              ),
              SizedBox(height: 16),
              Text(
                'Ficha Pet',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 32),
              CircularProgressIndicator(color: Colors.indigo),
            ],
          ),
        ),
      ),
    );
  }
}
