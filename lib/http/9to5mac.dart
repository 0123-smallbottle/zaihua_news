import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

class NineToFiveMac {
  static final Dio _dio = Dio();

  static Future<Map<String, String>> getArticleContent(String url) async {
    try {
      final response = await _dio.get(url);
      
      if (response.statusCode == 200) {
        final document = parser.parse(response.data);
        
        // Get title from h1
        final titleElement = document.querySelector('h1.h1');
        final title = titleElement?.text.trim() ?? '';
        
        // Get content from container with class 'post-content'
        final contentElement = document.querySelector('.post-content');
        final content = contentElement?.text.trim() ?? '';
        
        return {
          'title': title,
          'content': content,
        };
      }
      
      return {
        'title': 'Error',
        'content': 'Failed to load content',
      };
    } catch (e) {
      return {
        'title': 'Error',
        'content': 'Exception: ${e.toString()}',
      };
    }
  }
}
