import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../math.dart';
import 'page3.dart';
import 'page5.dart';

// 故事2 第4页 文本内容（后续可填充）
const String kStory2Page4Text = '三个小伙伴迫不及待地甩掉凉鞋，脚丫刚触到溪水就像触电般缩回来 —— 原来是山泉水特有的凉意，';

class Story2Page4 extends StatefulWidget {
  const Story2Page4({super.key});

  @override
  State<Story2Page4> createState() => _Story2Page4State();
}

class _Story2Page4State extends State<Story2Page4> {
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

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    try {
      await _flutterTts!.setLanguage('zh-CN');
    } catch (_) {}
    try {
      await _flutterTts!.setSpeechRate(0.6);
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(1.3);
      setState(() {
        _isTtsInitialized = true;
      });
      _speakStoryText();
    } catch (_) {}
  }

  Future<void> _speakStoryText() async {
    if (!_isTtsInitialized || _flutterTts == null) return;
    if (kStory2Page4Text.isEmpty) return;
    try {
      await _flutterTts!.speak(kStory2Page4Text);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/maths/story2/page4.png',
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),
          // 返回math页面按钮
          Positioned(
            top: -40,
            left: -30,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MathPage()),
                  (route) => false,
                );
              },
              child: Image.asset(
                'assets/images/maths/math.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 重播按钮
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: _speakStoryText,
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
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Story2Page3(),
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
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Story2Page5(),
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
          // 文本展示（若有）
          if (kStory2Page4Text.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    kStory2Page4Text,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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


