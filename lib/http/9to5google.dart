import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class NineToFiveGoogle {
  static Future<Map<String, String>> getArticleContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load article');
      }

      final document = parse(response.body);
      final title = document.querySelector('h1.h1')?.text.trim() ?? '';
      
      final contentElement = document.querySelector('.post-content');
      final content = contentElement?.text.trim() ?? '';

      return {
        'title': title,
        'content': content,
      };
    } catch (e) {
      throw Exception('Error parsing 9to5Google article: $e');
    }
  }
}
