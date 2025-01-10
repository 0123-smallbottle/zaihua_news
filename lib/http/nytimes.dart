import 'package:html/parser.dart';
import 'init.dart';

class NYTimes {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.getWithRetry(url, checkAntiBot: true);
      final document = parse(response.data);

      final title = document.querySelector('[data-testid="headline"]')?.text.trim() ?? '';
      final contentElement = document.querySelector('section[name="articleBody"]');
      final paragraphs = contentElement?.getElementsByTagName('p') ?? [];
      final content = paragraphs.map((p) => p.text.trim()).join('\n\n');

      if (title.isEmpty || content.isEmpty) {
        throw Exception('Failed to parse NYTimes content - possible paywall');
      }

      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception('Error parsing NYTimes article: $e');
    }
  }
}
