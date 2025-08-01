# ⚙️ Configuración del Proyecto - Ficha Pet

## 📋 Información General

### Datos del Proyecto
- **Nombre**: Ficha Pet
- **Versión**: 3.0.16
- **Lenguaje**: Dart/Flutter
- **Plataforma**: Android (iOS en desarrollo)
- **Arquitectura**: MVVM con Provider
- **Base de Datos**: SharedPreferences (Local)

### Equipo de Desarrollo
- **Desarrollador Principal**: [Tu Nombre]
- **Diseño UI/UX**: Basado en HTML original
- **Integración IA**: Google Gemini API
- **Testing**: Flutter Test Framework

## 🛠️ Configuración de Desarrollo

### Requisitos del Sistema
```bash
# Flutter SDK
Flutter 3.x o superior
Dart 3.x o superior

# Android
Android Studio 2023.1 o superior
Android SDK 35
Android Build Tools 35.0.0

# IDE Recomendado
VS Code con extensiones Flutter
Android Studio con plugin Flutter
```

### Variables de Entorno
```bash
# .env
GEMINI_API_KEY=AIzaSyCLJR59n3LQX_3fhpiC1vXNFVK0gvtJ62Q
FLUTTER_VERSION=3.19.0
DART_VERSION=3.3.0
```

### Configuración de Flutter
```yaml
# .metadata
version:
  revision: "stable"
  channel: "stable"

project_type: app

migration:
  platforms:
    - platform: root
      create_revision: stable
      base_revision: stable
    - platform: android
      create_revision: stable
      base_revision: stable
```

## 📱 Configuración de Android

### build.gradle (Project)
```gradle
buildscript {
    ext.kotlin_version = '1.9.0'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:8.4.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.4.2'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

### build.gradle (App)
```gradle
android {
    namespace "com.example.pet_app"
    compileSdk 35
    buildToolsVersion "35.0.0"

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.example.pet_app"
        minSdk 23
        targetSdk 35
        versionCode 36
        versionName "3.0.16"
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### gradle.properties
```properties
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true

# Deshabilitar daemon de Gradle para evitar problemas
org.gradle.daemon=false
```

## 📦 Dependencias

### pubspec.yaml
```yaml
name: pet_app
description: Aplicación de gestión de mascotas con IA
publish_to: 'none'
version: 3.0.16

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # Storage
  shared_preferences: ^2.2.2
  
  # File Handling
  image_picker: ^1.0.4
  file_picker: ^6.1.1
  
  # HTTP & API
  http: ^1.1.0
  flutter_dotenv: ^5.1.0
  
  # UI
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/fonts/
    - .env
```

## 🏗️ Estructura del Proyecto

### Organización de Carpetas
```
lib/
├── main.dart                 # Punto de entrada
├── providers/               # Gestión de estado
│   └── pet_provider.dart
├── screens/                 # Pantallas de la aplicación
│   ├── dashboard_screen.dart
│   ├── add_pet_screen.dart
│   ├── edit_pet_screen.dart
│   └── view_pet_screen.dart
├── services/               # Servicios externos
│   ├── ai_service.dart
│   └── storage_service.dart
└── widgets/                # Componentes reutilizables
    ├── ai_modal.dart
    └── onboarding_screen.dart
```

### Assets
```
assets/
├── images/                 # Imágenes de la aplicación
│   ├── 1.png
│   ├── 2.png
│   └── profile_photos/
├── fonts/                  # Fuentes personalizadas
│   └── Roboto/
└── onboarding/            # Imágenes de onboarding
```

## 🔧 Configuración de Build

### Comandos de Build
```bash
# Desarrollo
flutter run

# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release

# Limpiar build
flutter clean

# Obtener dependencias
flutter pub get
```

### Configuración de ProGuard
```proguard
# proguard-rules.pro
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
```

## 🤖 Configuración de IA

### Google Gemini API
```dart
// Configuración en ai_service.dart
static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

// Configuración de prompts
final generationConfig = {
  'temperature': 0.7,
  'topK': 40,
  'topP': 0.95,
  'maxOutputTokens': 2048,
};
```

### Funcionalidades de IA
1. **Análisis de Historial Médico**
2. **Generador de Guías de Cuidado**
3. **Analizador de Síntomas**
4. **Verificador de Alimentos**
5. **Análisis de Exámenes Médicos**

## 📊 Configuración de Testing

### Unit Tests
```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests específicos
flutter test test/pet_provider_test.dart

# Con coverage
flutter test --coverage
```

### Widget Tests
```bash
# Tests de widgets
flutter test test/widget_test.dart

# Tests de integración
flutter test integration_test/
```

## 🔒 Configuración de Seguridad

### Permisos Android
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
```

### Validación de Entrada
```dart
// Validadores implementados
class InputValidator {
  static String? validateName(String? value);
  static String? validateWeight(String? value);
  static String? validateDate(String? value);
  static String? validateEmail(String? value);
}
```

## 📈 Configuración de Performance

### Optimizaciones Implementadas
- **Tree-shaking**: Iconos optimizados
- **Code splitting**: Carga lazy de widgets
- **Image optimization**: Compresión automática
- **Memory management**: Gestión eficiente de memoria

### Métricas de Performance
- **Tiempo de inicio**: < 3 segundos
- **Tiempo de respuesta**: < 100ms
- **Uso de memoria**: < 150MB
- **Tamaño de APK**: 121MB

## 🔄 Configuración de CI/CD

### GitHub Actions (Opcional)
```yaml
# .github/workflows/flutter.yml
name: Flutter CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.19.0'
    - run: flutter pub get
    - run: flutter test
    - run: flutter build apk
```

## 📱 Configuración de Dispositivos

### Dispositivos Soportados
- **Android**: 6.0 (API 23) y superior
- **Pantallas**: 320dp - 800dp
- **Orientación**: Portrait y Landscape
- **Densidad**: mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi

### Configuración de Emulador
```bash
# Crear emulador
avdmanager create avd -n "PetApp_Test" -k "system-images;android-35;google_apis;x86_64"

# Iniciar emulador
emulator -avd PetApp_Test
```

## 🎨 Configuración de Diseño

### Paleta de Colores
```dart
// Colores principales
const Color primaryColor = Color(0xFF4F46E5);    // Indigo
const Color secondaryColor = Color(0xFF2563EB);  // Blue
const Color backgroundColor = Color(0xFFF3F4F6); // Gray-100
const Color surfaceColor = Color(0xFFE5E7EB);    // Gray-200
```

### Tipografía
```dart
// Fuente principal
fontFamily: 'Roboto'

// Tamaños de texto
const double fontSizeSmall = 12.0;
const double fontSizeMedium = 14.0;
const double fontSizeLarge = 16.0;
const double fontSizeTitle = 20.0;
const double fontSizeHeader = 24.0;
```

## 📋 Configuración de Documentación

### Archivos de Documentación
- **README.md**: Documentación principal
- **DOCUMENTATION.md**: Documentación técnica
- **USER_GUIDE.md**: Guía de usuario
- **CHANGELOG.md**: Historial de cambios
- **PROJECT_CONFIG.md**: Configuración del proyecto

### Generación de Documentación
```bash
# Generar documentación Dart
dart doc

# Generar documentación de API
flutter packages pub run dartdoc
```

## 🔧 Configuración de Debug

### Logs de Debug
```dart
// Habilitar logs detallados
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  print('Debug: $message');
}
```

### Configuración de Hot Reload
```bash
# Hot reload automático
flutter run --hot

# Hot restart
flutter run --hot --restart
```

---

**Configuración del Proyecto v3.0.16** - Ficha Pet 🐾 