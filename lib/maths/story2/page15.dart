import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../math.dart';
import 'page14.dart';
import 'page16.dart';

// 故事2 第15页 文本内容（后续可填充）
const String kStory2Page15Text = '她笑眯眯地挥了挥缀着铃铛的魔法杖，清脆的声音在森林里回荡：“我是彩虹婆婆，想过桥就得答我的数学题哦！答错的话......” 老婆婆故意拉长语调，忽然变出一大把棒棒糖，“就只能看着这些美味被云朵怪兽吃光光啦！”';

class Story2Page15 extends StatefulWidget {
  const Story2Page15({super.key});

  @override
  State<Story2Page15> createState() => _Story2Page15State();
}

class _Story2Page15State extends State<Story2Page15> {
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
      await _flutterTts!.setLanguage("zh-CN");
      await _flutterTts!.setSpeechRate(0.6);
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(1.3);
      setState(() {
        _isTtsInitialized = true;
      });
      if (kStory2Page15Text.isNotEmpty) {
        _speakStoryText();
      }
    } catch (e) {
      print('TTS设置错误: $e');
    }
  }

  Future<void> _speakStoryText() async {
    if (!_isTtsInitialized || _flutterTts == null) return;
    try {
      await _flutterTts!.speak(kStory2Page15Text);
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
          // 背景图片
          Positioned.fill(
            child: Image.asset(
              'assets/images/maths/story2/page15.png',
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

          // 重新朗读按钮
          if (kStory2Page15Text.isNotEmpty)
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
          // 上一页按钮（左侧）
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Story2Page14(),
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
          // 下一页按钮（右侧）
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Story2Page16(),
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
          // 文本显示区域（底部）
          if (kStory2Page15Text.isNotEmpty)
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
                  child: Text(
                    kStory2Page15Text,
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
          // 页码显示
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  '15',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
