import 'package:html/parser.dart';
import 'init.dart';

class Reuters {
  static Future<WebContent> getArticleContent(String url) async {
    final response = await HttpClient.getWithRetry(url, checkAntiBot: true);
    
    final document = parse(response.data);
    final title = document.querySelector('[data-testid="Heading"]')?.text.trim() ?? '';
    final contentElements = document.getElementsByClassName('article-body__content__17Yit');
    final content = contentElements.map((element) => element.text).join('\n').trim();

    return WebContent(title: title, content: content);
  }
}
