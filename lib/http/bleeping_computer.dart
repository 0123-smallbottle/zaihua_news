import 'package:html/parser.dart';
import 'init.dart';

class BleepingComputer {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.instance.get(url);
      final document = parse(response.data);

      final articleSection = document.querySelector('.article_section');
      final title = articleSection?.querySelector('h1')?.text.trim() ?? '';
      final contentElement = document.querySelector('.articleBody');
      final content = contentElement?.text.trim() ?? '';

      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception('Error parsing BleepingComputer article: $e');
    }
  }
}
