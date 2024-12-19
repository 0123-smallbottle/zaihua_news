import 'package:html/parser.dart';
import 'init.dart';

class Reuters {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.instance.get(url);
      if (response.data.contains('Please enable JS') ||
          response.data.contains('captcha-delivery')) {
        throw Exception('Anti-bot protection detected');
      }

      final document = parse(response.data);
      final title = document.querySelector('[data-testid="Heading"]')?.text.trim() ?? '';
      final contentElements = document.getElementsByClassName('article-body__content__17Yit');
      final content = contentElements.map((element) => element.text).join('\n').trim();

      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception('Error parsing Reuters article: $e');
    }
  }
}
