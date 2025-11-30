import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:projek_akhir_edukasi/secrets.dart';

/// Service untuk memanggil API aimlapi.com sebagai chat assistant.
class AiService {
  AiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.aimlapi.com/v1',
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $aimlApiKey',
            },
            validateStatus: (int? status) => status != null && status >= 200 && status < 600,
          ),
        );

  final Dio _dio;

  Future<String?> getChatResponse(String prompt) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/chat/completions',
        data: <String, dynamic>{
          'model': 'gpt-4o',
          'messages': <Map<String, String>>[
            <String, String>{
              'role': 'system',
              'content':
                  "You are 'EduSpark', a friendly and knowledgeable AI study assistant for students.",
            },
            <String, String>{
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.7,
        },
      );

      // Jika status code bukan 200, log dan kembalikan pesan error yang lebih jelas.
      if (response.statusCode != 200) {
        debugPrint(
          'AiService HTTP error: ${response.statusCode} - ${response.data}',
        );
        return 'AI Service HTTP ${response.statusCode}: ${response.data}';
      }

      final data = response.data;
      if (data == null) {
        debugPrint('AiService: empty response body');
        return null;
      }

      final choices = data['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        debugPrint('AiService: no choices in response: $data');
        return null;
      }

      final firstChoice = choices.first as Map<String, dynamic>;
      final message = firstChoice['message'] as Map<String, dynamic>?;
      if (message == null) {
        debugPrint('AiService: no message in choice: $data');
        return null;
      }

      final content = message['content'] as String?;
      return content;
    } catch (e, stackTrace) {
      debugPrint('AiService error: $e');
      debugPrint('$stackTrace');
      // Kembalikan pesan error agar terlihat di UI dan memudahkan debugging.
      return 'AI Service error: $e';
    }
  }
}

