import 'package:html/parser.dart';
import 'init.dart';

class TheVerge {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.instance.get(url);
      final document = parse(response.data);
      
      final title = document.querySelector('h1.inline.font-polysans')?.text.trim() ?? '';
      final contentElements = document.querySelectorAll('p.duet--article--standard-paragraph');
      final content = contentElements.map((e) => e.text.trim()).join('\n\n');

      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception('Error parsing The Verge article: $e');
    }
  }
}
