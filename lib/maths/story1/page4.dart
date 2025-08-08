import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../math.dart';
import 'page5.dart';

class Story1Page4 extends StatefulWidget {
  const Story1Page4({super.key});

  @override
  State<Story1Page4> createState() => _Story1Page4State();
}

class _Story1Page4State extends State<Story1Page4> {
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
      const storyText = "屋里飘着一股暖暖的香气，墙上挂着用草莓酱画的太阳，桌子上摆着云朵形状的饼干。刺刺端来一杯蜂蜜茶：这是用晨露和铃兰花瓣泡的，喝了能听懂花草说话哦。";
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
          // 全屏显示故事第四页图片 - 填满整个屏幕，包括摄像头区域
          Positioned.fill(
            child: Image.asset(
              'assets/images/maths/story1/page4.png',
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
                          '故事1 - 第4页',
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
                      builder: (context) => const Story1Page5(),
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
                  '4',
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
