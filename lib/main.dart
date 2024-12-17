import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:zaihua_news/pages/home/index.dart';
import 'package:zaihua_news/pages/settings/index.dart';
import 'package:get/get.dart';
import 'package:zaihua_news/http/system_prompt.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:zaihua_news/utils/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize system prompt
  await SystemPromptService.initializeSystemPrompt();

  // Set Gemini API key
  final String apiKey = await Storage.getGeminiApiKey() ?? '';
  Gemini.init(apiKey: apiKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: ((lightDynamic, darkDynamic) {
        return GetMaterialApp(
          theme: ThemeData(
              colorScheme: lightDynamic ??
                  ColorScheme.fromSeed(seedColor: Colors.orange),
              useMaterial3: true),
          darkTheme: ThemeData(colorScheme: darkDynamic, useMaterial3: true),
          home: const HomePage(),
          initialRoute: "/",
          getPages: [
            GetPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            GetPage(
              name: '/settings',
              page: () => const SettingsPage(),
            ),
          ],
        );
      }),
    );
  }
}
