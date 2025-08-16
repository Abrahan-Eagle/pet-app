# 🚀 Configuración de Cursor para Flutter

## ✨ Características Configuradas

### 📁 Archivos de Configuración Creados
- `.cursorrules` - Reglas de IA para desarrollo Flutter
- `.vscode/settings.json` - Configuración del editor
- `.vscode/extensions.json` - Extensiones recomendadas
- `.vscode/launch.json` - Configuración de debugging
- `.vscode/tasks.json` - Tareas comunes de Flutter
- `.vscode/workspace.code-workspace` - Configuración del workspace
- `.vscode/flutter.code-snippets` - Snippets personalizados
- `.cursor/settings.json` - Configuración específica de Cursor
- `analysis_options.yaml` - Reglas de análisis mejoradas

### 🎯 Funcionalidades Principales

#### **Formateo Automático**
- Formateo automático al guardar
- Organización automática de imports
- Reglas de estilo consistentes

#### **Snippets Personalizados**
- `fstateless` - Widget StatelessWidget
- `fstateful` - Widget StatefulWidget
- `fprovider` - Consumer de Provider

#### **Tareas Rápidas**
- `Ctrl+Shift+P` → "Flutter: Get Packages"
- `Ctrl+Shift+P` → "Flutter: Clean"
- `Ctrl+Shift+P` → "Flutter: Build APK"
- `Ctrl+Shift+P` → "Flutter: Run Tests"

#### **Debugging Optimizado**
- Configuración para Debug, Profile y Release
- Breakpoints inteligentes
- Análisis automático de código

## 🛠️ Instalación de Extensiones

### **Extensiones Esenciales**
1. **Dart Code** - Soporte completo para Dart
2. **Flutter** - Framework de Flutter
3. **Flutter Widget Snippets** - Snippets adicionales

### **Extensiones Recomendadas**
- **Prettier** - Formateo de código
- **GitLens** - Mejor integración con Git
- **Error Lens** - Visualización de errores mejorada

## 🚀 Comandos Rápidos

### **Atajos de Teclado**
- `Ctrl+Shift+P` - Paleta de comandos
- `F5` - Iniciar debugging
- `Ctrl+F5` - Ejecutar sin debugging
- `Ctrl+Shift+F` - Buscar en archivos

### **Comandos de IA**
- `Ctrl+K` - Chat con IA
- `Ctrl+L` - Completado de código
- `Ctrl+I` - Generación de código

## 📋 Reglas de Desarrollo

### **Estructura del Proyecto**
```
lib/
├── main.dart
├── providers/          # Estado de la app
├── screens/           # Pantallas principales
├── widgets/           # Widgets reutilizables
├── services/          # Lógica de negocio
└── models/            # Modelos de datos
```

### **Convenciones de Código**
- Usar `const` constructors cuando sea posible
- Implementar manejo de errores apropiado
- Usar `async/await` en lugar de `.then()`
- Mantener widgets pequeños y reutilizables

## 🔧 Personalización

### **Modificar Snippets**
Edita `.vscode/flutter.code-snippets` para agregar tus propios snippets.

### **Cambiar Reglas de Análisis**
Modifica `analysis_options.yaml` para ajustar las reglas de linting.

### **Configurar Temas**
Ve a `File > Preferences > Color Theme` para cambiar el tema visual.

## 🐛 Solución de Problemas

### **Flutter SDK no encontrado**
1. Verifica que Flutter esté en tu PATH
2. Ejecuta `flutter doctor` en la terminal
3. Reinicia Cursor

### **Extensiones no funcionan**
1. Verifica que las extensiones estén instaladas
2. Reinicia Cursor
3. Ejecuta `flutter clean` y `flutter pub get`

### **Análisis de código lento**
1. Excluye carpetas de build en `.vscode/settings.json`
2. Usa `flutter analyze` en lugar del análisis en tiempo real
3. Ajusta las reglas en `analysis_options.yaml`

## 📚 Recursos Adicionales

- [Documentación oficial de Flutter](https://flutter.dev/docs)
- [Guía de Dart](https://dart.dev/guides)
- [Cursor Documentation](https://cursor.sh/docs)
- [Flutter Lints](https://dart.dev/tools/linter-rules)

## 🎉 ¡Listo para Desarrollar!

Tu editor Cursor está ahora completamente configurado para desarrollo Flutter. Disfruta de:
- ✨ Completado de código inteligente
- 🚀 Snippets personalizados
- 🔍 Análisis de código en tiempo real
- 🐛 Debugging optimizado
- 📱 Soporte completo para Flutter

¡Happy coding! 🎯

