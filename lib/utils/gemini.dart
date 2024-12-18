import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:zaihua_news/utils/storage.dart';

class GeminiAI {
  static Future<String> processContent(String title, String content, String url) async {
    try {
      final apiKey = await Storage.getGeminiApiKey();
      final modelName = await Storage.getGeminiModel() ?? '';
      final systemPrompt = await Storage.getSystemPrompt() ?? '';
      
      if (apiKey == null || apiKey.isEmpty) {
        return 'Please set Gemini API key in settings';
      }

      final model = GenerativeModel(
        model: modelName,
        apiKey: apiKey,
      );

      final prompt = '''$systemPrompt

Title: $title

Content: $content

Source URL: $url''';

      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'No response from AI';
      
    } catch (e) {
      return 'AI processing error: $e';
    }
  }

  static Stream<String> streamContent(String title, String content, String url) async* {
    try {
      final apiKey = await Storage.getGeminiApiKey();
      final modelName = await Storage.getGeminiModel() ?? '';
      final systemPrompt = await Storage.getSystemPrompt() ?? '';
      
      if (apiKey == null || apiKey.isEmpty) {
        yield 'Please set Gemini API key in settings';
        return;
      }

      final model = GenerativeModel(
        model: modelName,
        apiKey: apiKey,
      );

      final prompt = '''$systemPrompt

Title: $title

Content: $content

Source URL: $url''';

      final response = await model.generateContentStream([Content.text(prompt)]);
      
      await for (final chunk in response) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
      
    } catch (e) {
      yield 'AI processing error: $e';
    }
  }
}