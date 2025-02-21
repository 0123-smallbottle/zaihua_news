import 'package:html/parser.dart';
import 'init.dart';

class TechPowerUp {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.instance.get(url);
      final document = parse(response.data);

      final title = document.querySelector('.h1')?.text.trim() ?? '';
      final contentElement = document.querySelector('.text.p');
      final content = contentElement?.text.trim() ?? '';
      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception('Error parsing 9to5Google article: $e');
    }
  }
}
