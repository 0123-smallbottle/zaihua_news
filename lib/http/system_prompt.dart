import 'init.dart';
import 'package:zaihua_news/utils/storage.dart';

class SystemPromptService {
  static Future<void> initializeSystemPrompt() async {
    try {
      final response = await HttpClient.instance
          .get('https://alist.smallbottle2.top/d/local/zaihua/prompt.txt');
      await Storage.saveSystemPrompt(response.data);
    } catch (e) {
      print('Error loading system prompt: $e');
    }
  }
}
