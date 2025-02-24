import 'package:zaihua_news/http/9to5google.dart';
import 'package:zaihua_news/http/9to5mac.dart';
import 'package:zaihua_news/http/techcrunch.dart';
import 'package:get/get.dart';
import 'package:zaihua_news/utils/gemini.dart';
import 'package:zaihua_news/http/forbes.dart';
import 'package:zaihua_news/http/android_authority.dart';
import 'package:zaihua_news/http/reuters.dart';
import 'package:zaihua_news/http/tomshardware.dart';
import 'package:zaihua_news/http/the_verge.dart';
import 'package:zaihua_news/http/init.dart';
import 'package:zaihua_news/http/pymnts.dart';
import 'package:zaihua_news/http/android_police.dart';
import 'package:zaihua_news/http/bleeping_computer.dart';
import 'package:zaihua_news/http/nytimes.dart';
import 'package:zaihua_news/http/pcmag.dart';
import 'package:zaihua_news/http/techpowerup.dart';

class HomePageController extends GetxController {
  final url = ''.obs;
  final title = ''.obs;
  final content = ''.obs;

  void setUrl(String value) {
    url.value = value;
  }

  void generate() async {
    try {
      content.value = ''; // Clear existing content
      WebContent response;

      if (url.value.startsWith('https://9to5google.com')) {
        response = await NineToFiveGoogle.getArticleContent(url.value);
      } else if (url.value.startsWith('https://techcrunch.com')) {
        response = await TechCrunch.getArticleContent(url.value);
      } else if (url.value.startsWith('https://9to5mac.com')) {
        response = await NineToFiveMac.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.forbes.com')) {
        response = await Forbes.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.androidauthority.com')) {
        response = await AndroidAuthority.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.reuters.com')) {
        response = await Reuters.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.tomshardware.com')) {
        response = await Tomshardware.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.theverge.com')) {
        response = await TheVerge.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.pymnts.com')) {
        response = await Pymnts.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.androidpolice.com')) {
        response = await AndroidPolice.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.bleepingcomputer.com')) {
        response = await BleepingComputer.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.nytimes.com')) {
        response = await NYTimes.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.pcmag.com')) {
        response = await PCMag.getArticleContent(url.value);
      } else if (url.value.startsWith('https://www.techpowerup.com')) {
        response = await TechPowerUp.getArticleContent(url.value);
      } else {
        throw Exception('Unsupported website');
      }

      title.value = response.title;

      // Use stream for real-time updates
      await for (final chunk
          in GeminiAI.streamContent(title.value, response.content, url.value)) {
        content.value += chunk;
      }
    } catch (e) {
      content.value = 'Failed to load content: $e';
    }
  }
}
