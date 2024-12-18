import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class TechCrunch {
  static Future<Map<String, String>> getArticleContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load article');
      }

      final document = parse(response.body);
      final title = document.querySelector('h1.article-hero__title')?.text.trim() ?? '';
      
      final contentElements = document.querySelector('.entry-content')?.querySelectorAll('p');
      final content = contentElements
          ?.map((element) => element.text.trim())
          .where((text) => text.isNotEmpty)
          .join('\n\n') ?? '';

      return {
        'title': title,
        'content': content,
      };
    } catch (e) {
      throw Exception('Error parsing TechCrunch article: $e');
    }
  }
}
