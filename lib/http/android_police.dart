import 'package:html/parser.dart';
import 'init.dart';

class AndroidPolice {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.instance.get(url);
      final document = parse(response.data);

      final title = document.querySelector('.article-header-title')?.text.trim() ?? '';
      final contentElement = document.querySelector('.content-block-regular');
      final content = contentElement?.text.trim() ?? '';

      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception('Error parsing Android Police article: $e');
    }
  }
}
