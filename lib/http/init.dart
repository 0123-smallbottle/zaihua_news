import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

class HttpConfig {
  static const String userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36';
  static const Duration connectTimeout = Duration(seconds: 5);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  static const Map<String, String> browserHeaders = {
    'User-Agent': 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.260 Mobile Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Connection': 'keep-alive',
  };
}

class WebContent {
  final String title;
  final String content;

  WebContent({required this.title, required this.content});

  factory WebContent.fromResponse(String html) {
    final document = parse(html);
    final title = document.querySelector('title')?.text ?? 'Unknown Title';
    return WebContent(
      title: title,
      content: html,
    );
  }
}

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late final Dio dio;

  factory HttpClient() => _instance;

  HttpClient._internal() {
    dio = Dio(BaseOptions(
      connectTimeout: HttpConfig.connectTimeout,
      receiveTimeout: HttpConfig.receiveTimeout,
      headers: {'User-Agent': HttpConfig.userAgent},
      validateStatus: (status) => status != null && status < 500,
    ));

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[HTTP] ${obj.toString()}'),
      ),
    );
  }

  static Dio get instance => _instance.dio;

  static Future<Response> getWithRetry(
    String url, {
    Options? options,
    Map<String, dynamic>? queryParameters,
    bool checkAntiBot = false,
  }) async {
    int attempts = 0;
    while (attempts < HttpConfig.maxRetries) {
      try {
        final response = await instance.get(
          url,
          options: options?.copyWith(headers: HttpConfig.browserHeaders) ?? 
                  Options(headers: HttpConfig.browserHeaders),
          queryParameters: queryParameters,
        );

        if (checkAntiBot && (
            response.data.toString().contains('Please enable JS') ||
            response.data.toString().contains('captcha-delivery'))) {
          attempts++;
          if (attempts >= HttpConfig.maxRetries) {
            throw Exception('Anti-bot protection could not be bypassed after ${HttpConfig.maxRetries} attempts');
          }
          await Future.delayed(HttpConfig.retryDelay);
          continue;
        }

        return response;
      } catch (e) {
        attempts++;
        if (attempts >= HttpConfig.maxRetries) {
          throw Exception('Failed after ${HttpConfig.maxRetries} attempts: $e');
        }
        await Future.delayed(HttpConfig.retryDelay);
      }
    }
    throw Exception('Unexpected error in HTTP request');
  }

  static Future<WebContent> getWebpage(String url) async {
    try {
      final response = await getWithRetry(
        url,
        options: Options(responseType: ResponseType.plain),
      );
      return WebContent.fromResponse(response.data);
    } on DioException catch (e) {
      throw Exception('網路請求失敗: ${e.message}');
    } catch (e) {
      throw Exception('解析內容失敗: $e');
    }
  }
}
