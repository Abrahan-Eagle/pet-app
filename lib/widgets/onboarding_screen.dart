import 'package:flutter/material.dart';

import 'package:zonix/services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: '¡Bienvenido a Ficha Pet!',
      description:
          'Esta es una guía rápida para mostrarte cómo funciona la app. ¡Vamos a empezar!',
      icon: Icons.pets,
      iconColor: Colors.amber,
    ),
    OnboardingPage(
      title: 'Maneja Múltiples Mascotas',
      description:
          'Desde la pantalla principal, puedes ver a todas tus mascotas. Usa el botón "Agregar Mascota" para crear una nueva ficha.\n\nCada mascota tendrá su propia ficha individual.',
      icon: Icons.people,
      iconColor: Colors.blue,
    ),
    OnboardingPage(
      title: 'Funciones con IA ✨',
      description:
          'Hemos integrado la IA de Gemini para ayudarte:\n\n• Analizar Historial: Obtén un resumen de las notas médicas\n• Analizar Exámenes: Sube una foto de un examen y la IA te lo explicará\n• Guía de Cuidado: Recibe consejos personalizados para tu mascota\n• Analizar Síntomas y Alimentos: Consulta rápidamente sobre síntomas o si un alimento es seguro',
      icon: Icons.auto_awesome,
      iconColor: Colors.purple,
    ),
    OnboardingPage(
      title: '¡Todo Listo!',
      description:
          'Toda tu información se guarda de forma segura en tu dispositivo. ¡Ya puedes empezar a crear las fichas de tus mascotas!',
      icon: Icons.check_circle,
      iconColor: Colors.green,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text(
                    'Saltar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Navigation
              _buildNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.iconColor,
            ),
          ),
          const SizedBox(height: 32),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          if (_currentPage > 0)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Anterior'),
            )
          else
            const SizedBox(width: 80),

          // Dots indicator
          Row(
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentPage == index ? Colors.indigo : Colors.grey[300],
                ),
              ),
            ),
          ),

          // Next/Finish button
          ElevatedButton(
            onPressed: _currentPage == _pages.length - 1
                ? _finishOnboarding
                : () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
                _currentPage == _pages.length - 1 ? 'Finalizar' : 'Siguiente'),
          ),
        ],
      ),
    );
  }

  void _finishOnboarding() async {
    await StorageService.setOnboardingComplete();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}
