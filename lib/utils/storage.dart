import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> saveGeminiApiKey(String apiKey) async {
    await _storage.write(key: 'gemini_api_key', value: apiKey);
  }

  static Future<String?> getGeminiApiKey() async {
    return await _storage.read(key: 'gemini_api_key');
  }

  static Future<void> saveGeminiModel(String model) async {
    await _storage.write(key: 'gemini_model_name', value: model);
  }

  static Future<String?> getGeminiModel() async {
    return await _storage.read(key: 'gemini_model_name');
  }

  static Future<void> saveSystemPrompt(String prompt) async {
    await _storage.write(key: 'system_prompt', value: prompt);
  }

  static Future<String?> getSystemPrompt() async {
    return await _storage.read(key: 'system_prompt');
  }
}