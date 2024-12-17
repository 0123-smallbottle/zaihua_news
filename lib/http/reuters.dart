import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Reuters {
  static Future<Map<String, String>> getArticleContent(String url) async {
    try {
      final headers = {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.5',
        'Connection': 'keep-alive',
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to load article: ${response.statusCode}');
      }

      if (response.body.contains('Please enable JS') ||
          response.body.contains('captcha-delivery')) {
        throw Exception('Anti-bot protection detected');
      }

      final document = parse(response.body);

      final title =
          document.querySelector('[data-testid="Heading"]')?.text.trim() ?? '';

      final contentElements =
          document.getElementsByClassName('article-body__content__17Yit');
      final content =
          contentElements.map((element) => element.text).join('\n').trim();

      return {
        'title': title,
        'content': content,
      };
    } catch (e) {
      throw Exception('Error parsing Reuters article: $e');
    }
  }
}
