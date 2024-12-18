import 'package:zaihua_news/http/9to5google.dart';
import 'package:zaihua_news/http/9to5mac.dart';
import 'package:zaihua_news/http/techcrunch.dart';
import 'package:get/get.dart';
import 'package:zaihua_news/utils/gemini.dart';
import 'package:zaihua_news/http/forbes.dart';
import 'package:zaihua_news/http/android_authority.dart';
import 'package:zaihua_news/http/reuters.dart';
import 'package:zaihua_news/http/tomshardware.dart ';

class HomePageController extends GetxController {
  final url = ''.obs;
  final title = ''.obs;
  final content = ''.obs;

  void setUrl(String value) {
    url.value = value;
  }

  void generate() async {
    try {
      content.value = ''; // Clear existing content
      Map<String, String> response;
      
      if (url.value.startsWith('https://9to5google.com')) {
        response = await NineToFiveGoogle.getArticleContent(url.value);
      } else if (url.value.startsWith('https://techcrunch.com')) {
        response = await TechCrunch.getArticleContent(url.value);
      } else if (url.value.startsWith('https://9to5mac.com')) {
        response = await NineToFiveMac.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.forbes.com')) {
        response = await Forbes.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.androidauthority.com')) {
        response = await AndroidAuthority.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.reuters.com')) {
        response = await Reuters.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.tomshardware.com')) {
        response = await Tomshardware.getArticleContent(url.value);
      } else {
        throw Exception('Unsupported website');
      }

      title.value = response['title'] ?? '';
      final rawContent = response['content'] ?? '';
      
      // Use stream for real-time updates
      await for (final chunk in GeminiAI.streamContent(title.value, rawContent, url.value)) {
        content.value += chunk;
      }
    } catch (e) {
      content.value = 'Failed to load content: $e';
    }
  }
}
