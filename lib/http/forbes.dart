import 'package:html/parser.dart';
import 'init.dart';

class Forbes {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.instance.get(url);
      final document = parse(response.data);
      
      final title = document.querySelector('.fs-headline')?.text.trim() ?? '';
      final contentElements = document.querySelectorAll('.article-body');
      final content = contentElements
          .map((element) => element.text)
          .join('\n')
          .trim();

      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception('Error parsing Forbes article: $e');
    }
  }
}
