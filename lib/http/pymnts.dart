import 'package:html/parser.dart';
import 'init.dart';

class Pymnts {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.instance.get(url);
      final document = parse(response.data);

      final title =
          document.querySelector('.elementToProof')?.text.trim() ?? '';
      final contentElement = document.querySelector('.article-content');
      final content = contentElement?.text.trim() ?? '';

      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception('Error parsing PYMNTS article: $e');
    }
  }
}
