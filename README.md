# 🐾 Ficha Pet - Aplicación de Gestión de Mascotas

## 📋 Descripción

**Ficha Pet** es una aplicación móvil desarrollada en Flutter que permite a los usuarios gestionar de manera completa la información de sus mascotas. La aplicación incluye funcionalidades avanzadas de IA para análisis médico y proporciona una interfaz intuitiva y moderna.

## ✨ Características Principales

### 🏠 Dashboard Principal
- **Vista de Grid Responsivo** - Lista todas las mascotas en un diseño atractivo
- **Botón de Agregar Mascota** - Acceso rápido para crear nuevas fichas
- **Navegación Fluida** - Transiciones suaves entre pantallas

### 📝 Gestión Completa de Mascotas
- **Información Básica**: Nombre, tipo, género, fecha de nacimiento
- **Datos Físicos**: Peso, raza, microchip
- **Información Médica**: Vacunas, desparasitación, historial médico
- **Archivos Adjuntos**: Imágenes de mascota, carnet de vacunación, exámenes médicos

### 🤖 Integración con IA (Gemini API)
- **Análisis de Historial Médico** - Resumen inteligente de notas médicas
- **Generador de Guías de Cuidado** - Consejos personalizados por mascota
- **Analizador de Síntomas** - Evaluación de urgencia médica
- **Verificador de Alimentos** - Seguridad alimentaria para mascotas
- **Análisis de Exámenes Médicos** - Interpretación de imágenes (JPG, PNG, etc.)

### 💾 Persistencia de Datos
- **Almacenamiento Local** - Datos guardados automáticamente
- **Gestión de Estado** - Provider pattern para manejo eficiente
- **Sincronización** - Cambios reflejados inmediatamente

### 🎨 Interfaz de Usuario
- **Diseño Material 3** - Interfaz moderna y accesible
- **Gradientes Personalizados** - Fondo idéntico al diseño HTML original
- **Responsive Design** - Adaptable a diferentes tamaños de pantalla
- **Onboarding** - Guía inicial para nuevos usuarios

## 🛠️ Tecnologías Utilizadas

### Frontend
- **Flutter 3.x** - Framework principal
- **Dart** - Lenguaje de programación
- **Material Design 3** - Sistema de diseño

### Backend & Servicios
- **Provider** - Gestión de estado
- **SharedPreferences** - Almacenamiento local
- **HTTP** - Comunicación con APIs
- **Gemini API** - Servicios de IA

### Utilidades
- **Image Picker** - Selección de imágenes
- **File Picker** - Gestión de archivos
- **Base64** - Codificación de archivos
- **Flutter Dotenv** - Variables de entorno

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── providers/
│   └── pet_provider.dart     # Gestión de estado de mascotas
├── screens/
│   ├── dashboard_screen.dart # Pantalla principal
│   ├── add_pet_screen.dart   # Crear nueva mascota
│   ├── edit_pet_screen.dart  # Editar mascota existente
│   └── view_pet_screen.dart  # Ver detalles de mascota
├── services/
│   ├── ai_service.dart       # Servicios de IA
│   └── storage_service.dart  # Persistencia de datos
└── widgets/
    ├── ai_modal.dart         # Modal para análisis IA
    └── onboarding_screen.dart # Pantalla de onboarding
```

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK 3.x o superior
- Android Studio / VS Code
- Dispositivo Android o emulador

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd pet-app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar variables de entorno**
   ```bash
   # Crear archivo .env en la raíz del proyecto
   echo "GEMINI_API_KEY=tu_api_key_aqui" > .env
   ```

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

### Configuración de la API de IA

1. Obtener una API key de Google Gemini:
   - Visitar [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Crear una nueva API key
   - Copiar la key al archivo `.env`

2. Configurar el archivo `.env`:
   ```
   GEMINI_API_KEY=AIzaSyCLJR59n3LQX_3fhpiC1vXNFVK0gvtJ62Q
   ```

## 📱 Funcionalidades Detalladas

### 1. Dashboard Principal
- **Vista de mascotas**: Grid responsivo con tarjetas de mascotas
- **Información visible**: Nombre, tipo, imagen de perfil
- **Acciones rápidas**: Ver detalles, editar, eliminar

### 2. Gestión de Mascotas

#### Información Básica
- **Nombre**: Identificación principal de la mascota
- **Tipo**: Perro, gato, u otros animales
- **Género**: Macho o hembra
- **Fecha de nacimiento**: Para cálculo de edad
- **Peso**: En kilogramos
- **Raza**: Especificación de la raza
- **Microchip**: Si tiene o no microchip

#### Información Médica
- **Vacunación**:
  - Última fecha de vacunación
  - Próxima fecha de vacunación
  - Tipo de vacunas aplicadas
  - Imagen del carnet de vacunación

- **Desparasitación**:
  - Última fecha de desparasitación
  - Próxima fecha de desparasitación
  - Producto utilizado

#### Historial Médico
- **Entradas cronológicas**: Fecha y descripción de eventos médicos
- **Gestión completa**: Agregar, editar, eliminar entradas
- **Análisis IA**: Resumen inteligente del historial

#### Exámenes Médicos
- **Soporte múltiple**: JPG, PNG, PDF
- **Almacenamiento**: Base64 para persistencia
- **Análisis IA**: Interpretación de imágenes médicas

### 3. Funcionalidades de IA

#### Análisis de Historial Médico
```dart
// Ejemplo de uso
await AIService.analyzeMedicalHistory(medicalHistory);
```

#### Generación de Guías de Cuidado
```dart
// Ejemplo de uso
await AIService.generateCareGuide(
  petType: 'dog',
  age: '3 years',
  breed: 'Golden Retriever',
  weight: '25.5 kg'
);
```

#### Analizador de Síntomas
```dart
// Ejemplo de uso
await AIService.analyzeSymptoms(
  symptoms: 'Letargia, pérdida de apetito',
  petType: 'cat',
  age: '2 years'
);
```

#### Verificador de Alimentos
```dart
// Ejemplo de uso
await AIService.checkFood(
  food: 'Chocolate',
  petType: 'dog',
  weight: '15 kg'
);
```

#### Análisis de Exámenes
```dart
// Ejemplo de uso
await AIService.analyzeExam(
  examName: 'Radiografía de tórax',
  imageData: imageBytes
);
```

## 🎨 Diseño y UI/UX

### Paleta de Colores
- **Primario**: Indigo (#4F46E5)
- **Secundario**: Blue (#2563EB)
- **Fondo**: Gradiente gris claro (#F3F4F6 → #E5E7EB)
- **Acentos**: Verde para acciones positivas, rojo para alertas

### Componentes de Diseño
- **Tarjetas**: Bordes redondeados con sombras suaves
- **Botones**: Gradientes con efectos de hover
- **Iconos**: Material Design Icons
- **Tipografía**: Roboto para consistencia

### Responsive Design
- **Grid adaptativo**: Se ajusta al número de mascotas
- **Espaciado flexible**: Márgenes y padding responsivos
- **Navegación intuitiva**: Gestos y transiciones fluidas

## 🔧 Configuración de Build

### Android
```gradle
// android/app/build.gradle
android {
    compileSdk 35
    buildToolsVersion "35.0.0"
    
    defaultConfig {
        minSdk 23
        targetSdk 35
        versionCode 36
        versionName "3.0.16"
    }
}
```

### Optimizaciones
- **Tree-shaking**: Iconos optimizados
- **Dependencias limpias**: Solo paquetes esenciales
- **Código minificado**: Tamaño reducido para producción

## 📊 Gestión de Estado

### Provider Pattern
```dart
class PetProvider extends ChangeNotifier {
  List<Pet> _pets = [];
  
  // Getters
  List<Pet> get pets => _pets;
  
  // Métodos
  void addPet(Pet pet) { /* ... */ }
  void updatePet(Pet pet) { /* ... */ }
  void removePet(String id) { /* ... */ }
}
```

### Persistencia Local
```dart
class StorageService {
  static Future<void> savePets(List<Pet> pets) async { /* ... */ }
  static Future<List<Pet>> loadPets() async { /* ... */ }
}
```

## 🧪 Testing

### Pruebas Unitarias
```bash
flutter test
```

### Pruebas de Widget
```bash
flutter test test/widget_test.dart
```

## 📦 Build y Distribución

### APK de Debug
```bash
flutter build apk --debug
```

### APK de Release
```bash
flutter build apk --release
```

### APK Bundle (Google Play)
```bash
flutter build appbundle --release
```

## 🔒 Seguridad

### Variables de Entorno
- API keys almacenadas en `.env`
- Archivo `.env` incluido en `.gitignore`
- Validación de entrada en formularios

### Validación de Datos
- Verificación de tipos de archivo
- Sanitización de entrada de usuario
- Manejo de errores robusto

## 🐛 Solución de Problemas

### Errores Comunes

1. **Error de API Key**
   ```
   Solución: Verificar que el archivo .env existe y contiene la API key correcta
   ```

2. **Error de Build**
   ```
   Solución: flutter clean && flutter pub get
   ```

3. **Error de Permisos**
   ```
   Solución: Verificar permisos de archivos en AndroidManifest.xml
   ```

### Logs de Debug
```bash
flutter logs
```

## 📈 Roadmap

### Versión 1.1
- [ ] Sincronización en la nube
- [ ] Backup automático
- [ ] Notificaciones de recordatorios

### Versión 1.2
- [ ] Múltiples usuarios
- [ ] Compartir fichas
- [ ] Historial de cambios

### Versión 2.0
- [ ] Integración con veterinarios
- [ ] Telemedicina
- [ ] Marketplace de productos

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👥 Autores

- **Desarrollador Principal** - [Tu Nombre]
- **Diseño UI/UX** - Basado en HTML original
- **Integración IA** - Google Gemini API

## 🙏 Agradecimientos

- Google Gemini API por los servicios de IA
- Flutter Team por el framework
- Comunidad de Flutter por el soporte

---

**Ficha Pet** - Tu compañero digital para el cuidado de mascotas 🐾
