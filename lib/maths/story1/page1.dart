import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../math.dart';
import 'cover.dart';
import 'page2.dart';

class Story1Page1 extends StatefulWidget {
  const Story1Page1({super.key});

  @override
  State<Story1Page1> createState() => _Story1Page1State();
}

class _Story1Page1State extends State<Story1Page1> {
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
      const storyText = "雨后的森林像被撒了一把亮晶晶的糖，每片叶子上都滚着圆滚滚的水珠。小兔子跳跳举着胡萝卜叶子伞，蹦蹦跳跳地去找好朋友小松鼠。";
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

          // 全屏显示故事第一页图片 - 填满整个屏幕，包括摄像头区域
          Positioned.fill(
            child: Image.asset(
              'assets/images/maths/story1/page1.png',
              fit: BoxFit.fill,
              alignment: Alignment.center,
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Story1CoverPage(),
                    ),
                  );
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
                      builder: (context) => const Story1Page2(),
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
                  '1',
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
