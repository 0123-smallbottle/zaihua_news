import 'package:html/parser.dart';
import 'init.dart';

class PCMag {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.getWithRetry(url, checkAntiBot: true);
      final document = parse(response.data);
      
      final title = document.querySelector('h1.font-stretch-ultra-condensed')?.text.trim() ?? '';
      final contentElement = document.querySelector('article#article');
      final paragraphs = contentElement?.getElementsByTagName('p') ?? [];
      final content = paragraphs.map((p) => p.text.trim()).join('\n\n');

      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception('Error parsing PCMag article: $e');
    }
  }
}
