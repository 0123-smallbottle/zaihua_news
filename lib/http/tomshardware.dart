import 'package:html/parser.dart';
import 'init.dart';

class Tomshardware {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.instance.get(url);
      final document = parse(response.data);

      final title = document.querySelector('h1')?.text.trim() ?? '';
      final contentElements = document.querySelectorAll('div#article-body.text-copy.bodyCopy.auto');
      final content = contentElements.map((element) => element.text).join('\n').trim();

      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception("Error parsing Tom's Hardware article: $e");
    }
  }
}
