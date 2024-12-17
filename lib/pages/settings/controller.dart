import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaihua_news/utils/storage.dart';

class SettingsController extends GetxController {
  var apiKey = ''.obs;
  var modelName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    apiKey.value = await Storage.getGeminiApiKey() ?? '';
    modelName.value = await Storage.getGeminiModel() ?? '';
  }

  Future<void> saveSettings() async {
    await Storage.saveGeminiApiKey(apiKey.value);
    await Storage.saveGeminiModel(modelName.value);
    
    Get.snackbar(
      '成功',
      '設定已保存',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
    );
    
    Get.back();
  }
}
