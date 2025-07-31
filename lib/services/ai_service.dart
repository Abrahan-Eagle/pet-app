import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> callGeminiAPI(String prompt,
      {Uint8List? imageData}) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        return 'Error: API key no configurada. Por favor, configura tu API key de Gemini.';
      }

      final url = Uri.parse('$_baseUrl?key=$apiKey');

      List<Map<String, dynamic>> parts = [
        {'text': prompt}
      ];

      if (imageData != null) {
        parts.add({
          'inlineData': {
            'mimeType': 'image/png',
            'data': base64Encode(imageData)
          }
        });
      }

      final payload = {
        'contents': [
          {'role': 'user', 'parts': parts}
        ]
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
            'No se pudo obtener una respuesta de la IA.';
      } else {
        return 'Error al contactar la IA: ${response.statusCode}';
      }
    } catch (error) {
      return 'Error al contactar la IA: $error';
    }
  }

  // Análisis de historial médico
  static Future<String> analyzeMedicalHistory(
      List<Map<String, String>> history) async {
    if (history.isEmpty) {
      return 'No hay historial médico para analizar.';
    }

    final historyText =
        history.map((e) => '${e['date']}: ${e['text']}').join('\n');
    final prompt = '''
Eres un asistente veterinario experto. Resume el siguiente historial médico de una mascota en puntos clave. 
Destaca posibles preocupaciones o temas importantes para discutir con un veterinario. 
No ofrezcas un diagnóstico, solo un resumen para facilitar la conversación con un profesional.

El historial es:

$historyText
''';

    return await callGeminiAPI(prompt);
  }

  // Generar guía de cuidado
  static Future<String> generateCareGuide({
    required String name,
    required String type,
    required String breed,
    required String age,
    required String weight,
  }) async {
    final prompt = '''
Eres un experto en cuidado de mascotas. Genera una guía de cuidados amigable y personalizada para la siguiente mascota. 
Incluye consejos sobre ejercicio, dieta (sin recomendar marcas específicas), y problemas de salud comunes para su raza y edad. 
Formatea la respuesta con encabezados y listas.

- Nombre: $name
- Tipo: $type
- Raza: $breed
- Edad: $age
- Peso: $weight kg
''';

    return await callGeminiAPI(prompt);
  }

  // Analizar síntomas
  static Future<String> analyzeSymptoms({
    required String symptoms,
    required String name,
    required String type,
    required String breed,
    required String age,
    required String weight,
  }) async {
    final prompt = '''
Eres un asistente veterinario virtual. Una mascota llamada $name, que es un $type de raza $breed con $age y un peso de $weight kg, 
presenta los siguientes síntomas: "$symptoms". 

Proporciona una orientación general sobre posibles causas, sin dar un diagnóstico. 
Clasifica la urgencia en una de estas tres categorías:
- ACCIÓN INMEDIATA: Contacta a un veterinario de urgencia
- CONSULTA RECOMENDADA: Pide una cita con tu veterinario
- OBSERVACIÓN: Vigila a tu mascota en casa

Incluye una advertencia clara de que esta es solo una guía informativa y no reemplaza la consulta con un profesional.
''';

    return await callGeminiAPI(prompt);
  }

  // Verificar alimento
  static Future<String> checkFood({
    required String food,
    required String type,
  }) async {
    final prompt = '''
¿Un $type puede comer $food? Explica brevemente si es seguro, tóxico, o si se debe dar con moderación, y por qué.
''';

    return await callGeminiAPI(prompt);
  }

  // Analizar examen médico
  static Future<String> analyzeExam({
    required String examName,
    required Uint8List imageData,
  }) async {
    final prompt = '''
Eres un asistente veterinario experto. Analiza la siguiente imagen de un examen médico llamado "$examName" 
y explica los resultados en términos sencillos que un dueño de mascota pueda entender. 
No ofrezcas un diagnóstico definitivo, pero resalta cualquier valor que parezca fuera de lo normal 
y sugiere que se discuta con un veterinario.
''';

    return await callGeminiAPI(prompt, imageData: imageData);
  }
}
