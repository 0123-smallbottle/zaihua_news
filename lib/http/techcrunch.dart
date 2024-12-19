import 'package:html/parser.dart';
import 'init.dart';

class TechCrunch {
  static Future<WebContent> getArticleContent(String url) async {
    try {
      final response = await HttpClient.instance.get(url);
      final document = parse(response.data);
      
      final title = document.querySelector('h1.article-hero__title')?.text.trim() ?? '';
      final contentElements = document.querySelector('.entry-content')?.querySelectorAll('p');
      final content = contentElements
          ?.map((element) => element.text.trim())
          .where((text) => text.isNotEmpty)
          .join('\n\n') ?? '';

      return WebContent(title: title, content: content);
    } catch (e) {
      throw Exception('Error parsing TechCrunch article: $e');
    }
  }
}
