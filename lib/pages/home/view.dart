import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'controller.dart';
import 'package:zaihua_news/pages/settings/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('在花發稿助手'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.lazyPut(() => SettingsController());
              Get.toNamed('/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '輸入鏈接',
                  ),
                  onChanged: (value) => controller.setUrl(value),
                ),
                SizedBox(height: 12), // Added SizedBox for spacing
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  onPressed: () => controller.generate(),
                  child: const Text('生成'),
                ),
              ],
            ),
          ),
          SizedBox(height: 12), // Added SizedBox for spacing
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Obx(() => MarkdownBody(
                          data: controller.content.value,
                          selectable: true,
                        )),
                      ),
                      // 為底部按鈕預留空間
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Obx(() => Visibility(
                    visible: controller.content.value.isNotEmpty,
                    child: FloatingActionButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                          text: controller.content.value
                        ));
                        Get.snackbar(
                          '成功', 
                          '內容已複製到剪貼簿',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: const Icon(Icons.copy),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
