import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class TheVerge {
  static Future<Map<String, String>> getArticleContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load article');
      }

      final document = parse(response.body);
      final title =
          document.querySelector('h1.inline.font-polysans')?.text.trim() ?? '';

      final contentElements =
          document.querySelectorAll('p.duet--article--standard-paragraph');
      final content = contentElements.map((e) => e.text.trim()).join('\n\n');

      if (title.isEmpty || content.isEmpty) {
        throw Exception('Failed to extract article content');
      }

      return {
        'title': title,
        'content': content,
      };
    } catch (e) {
      throw Exception('Error parsing The Verge article: $e');
    }
  }
}
