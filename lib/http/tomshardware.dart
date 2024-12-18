import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Tomshardware {
  static Future<Map<String, String>> getArticleContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load article');
      }

      final document = parse(response.body);

      final title = document.querySelector('h1')?.text.trim() ?? '';

      final contentElements = document.querySelectorAll('div#article-body.text-copy.bodyCopy.auto');
      
      final content =
          contentElements.map((element) => element.text).join('\n').trim();

      return {
        'title': title,
        'content': content,
      };
    } catch (e) {
      throw Exception("Error parsing Tom's Hardware article: $e");
    }
  }
}
