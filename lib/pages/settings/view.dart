import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Gemini API Key',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => controller.apiKey.value = value,
                  controller:
                      TextEditingController(text: controller.apiKey.value),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Model Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => controller.modelName.value = value,
                  controller:
                      TextEditingController(text: controller.modelName.value),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.saveSettings();
                  },
                  child: const Text('儲存'),
                ),
              ],
            )),
      ),
    );
  }
}
