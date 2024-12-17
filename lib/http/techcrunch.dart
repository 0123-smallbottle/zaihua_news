import 'package:html/parser.dart';
import './init.dart';

class TechCrunch {
  static Future<Map<String, String>> getArticleContent(String url) async {
    try {
      final response = await HttpClient.instance.get(url);
      final document = parse(response.data);

      // 獲取文章標題
      final title =
          document.querySelector('h1.article-hero__title')?.text.trim() ?? '';

      // 獲取文章內容
      final contentElements =
          document.querySelector('.entry-content')?.querySelectorAll('p');

      final contentList = contentElements
              ?.map((element) => element.text.trim())
              .where((text) => text.isNotEmpty)
              .toList() ??
          [];

      final content = contentList.join('\n\n');

      return {
        'title': title,
        'content': content,
      };
    } catch (e) {
      throw Exception('Failed to parse TechCrunch article: $e');
    }
  }
}
