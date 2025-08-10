import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../math.dart';
import 'page3.dart';
import 'page1.dart';

// 故事2 第2页 文本内容（后续可填充）
const String kStory2Page2Text = '“看！那边有会唱歌的小溪！” 乐乐踮着脚尖，把蘑菇形状的遮阳帽往后推了推，指着林间闪着光的水流喊。';

class Story2Page2 extends StatefulWidget {
  const Story2Page2({super.key});

  @override
  State<Story2Page2> createState() => _Story2Page2State();
}

class _Story2Page2State extends State<Story2Page2> {
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
    if (kStory2Page2Text.isEmpty) return;
    try {
      await _flutterTts!.speak(kStory2Page2Text);
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
              'assets/images/maths/story2/page2.png',
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
                      builder: (context) => const Story2Page1(),
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
                      builder: (context) => const Story2Page3(),
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
          if (kStory2Page2Text.isNotEmpty)
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
                    kStory2Page2Text,
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
                  '2',
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


