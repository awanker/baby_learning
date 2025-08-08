import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../math.dart';
import 'page13.dart';

class Story1Page12 extends StatefulWidget {
  const Story1Page12({super.key});

  @override
  State<Story1Page12> createState() => _Story1Page12State();
}

class _Story1Page12State extends State<Story1Page12> {
  FlutterTts? _flutterTts;
  bool _isTtsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  @override
  void dispose() {
    _flutterTts?.stop();
    super.dispose();
  }

  // 初始化TTS
  Future<void> _initTts() async {
    _flutterTts = FlutterTts();

    try {
      // 设置语言为中文
      await _flutterTts!.setLanguage("zh-CN");
    } catch (e) {
      // 如果中文不可用，使用默认语言
      print('中文TTS不可用，使用默认语言: $e');
    }

    try {
      // 设置语速 - 稍微快一点，模拟儿童说话
      await _flutterTts!.setSpeechRate(0.6);
      // 设置音量
      await _flutterTts!.setVolume(1.0);
      // 设置音调 - 提高音调，模拟儿童声音
      await _flutterTts!.setPitch(1.3);
      
      setState(() {
        _isTtsInitialized = true;
      });
      
      // TTS初始化完成后，开始朗读故事文本
      _speakStoryText();
    } catch (e) {
      print('TTS设置错误: $e');
    }
  }

  // 朗读故事文本
  Future<void> _speakStoryText() async {
    if (!_isTtsInitialized || _flutterTts == null) return;
    
    try {
      const storyText = "明天还能再见到蘑菇屋吗？跳跳有点舍不得。刺刺指指天上的彩虹：当第一缕阳光吻过三棵老松树时，勇敢的孩子总能找到惊喜哦。";
      await _flutterTts!.speak(storyText);
    } catch (e) {
      print('朗读故事文本失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 全屏显示故事第十二页图片 - 填满整个屏幕，包括摄像头区域
          Positioned.fill(
            child: Image.asset(
              'assets/images/maths/story1/page12.png',
              fit: BoxFit.fill,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                print('图片加载错误: $error');
                return Container(
                  color: Colors.blue[100],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book,
                          size: 100,
                          color: Colors.blue,
                        ),
                        SizedBox(height: 20),
                        Text(
                          '故事1 - 第12页',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '图片加载失败',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // 重新朗读按钮
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                _speakStoryText();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),

          // 上一页按钮（左侧居中）
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          // 下一页按钮（右侧居中）
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Story1Page13(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),

          // 页面编号
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  '12',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
