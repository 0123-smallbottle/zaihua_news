import 'package:dio/dio.dart';
import 'package:zaihua_news/utils/storage.dart';

class SystemPromptService {
  static final Dio _dio = Dio();
  
  static Future<void> initializeSystemPrompt() async {
    try {
      final response = await _dio.get('https://alist.smallbottle2.top/d/local/zaihua/prompt.txt');
      if (response.statusCode == 200) {
        await Storage.saveSystemPrompt(response.data);
      }
    } catch (e) {
      print('Error loading system prompt: $e');
    }
  }
}
