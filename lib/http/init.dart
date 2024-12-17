import 'package:dio/dio.dart';

class HttpConfig {
  // Global configurations
  static const String userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36';
}

class WebContent {
  final String title;
  final String content;

  WebContent({required this.title, required this.content});
}

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late final Dio dio;

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() {
    dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'User-Agent': HttpConfig.userAgent,
      },
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  static Dio get instance => _instance.dio;

  static const int connectTimeout = 8000;

  static const int receiveTimeout = 5000;
  // Helper method to fetch webpage content with title
  static Future<WebContent> getWebpage(String url) async {
    try {
      final response = await instance.get(url);
      // You'll need to implement the actual title extraction logic based on your needs
      String title = ''; // Extract title from response
      return WebContent(title: title, content: response.data.toString());
    } catch (e) {
      throw Exception('Failed to load webpage: $e');
    }
  }
}
