import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../math.dart';
import 'page15.dart';

// 故事2 第16页 文本内容（后续可填充）
const String kStory2Page16Text = '乐乐、朵朵和天天踮着脚尖，眼睛亮晶晶地望着彩虹婆婆，迫不及待地说：“婆婆快出题！”';

class Story2Page16 extends StatefulWidget {
  const Story2Page16({super.key});

  @override
  State<Story2Page16> createState() => _Story2Page16State();
}

class _Story2Page16State extends State<Story2Page16> with TickerProviderStateMixin {
  FlutterTts? _flutterTts;
  bool _isTtsInitialized = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initTts();
    _initGlowAnimation();
  }

  @override
  void dispose() {
    _flutterTts?.stop();
    _glowController.dispose();
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
      if (kStory2Page16Text.isNotEmpty) {
        _speakStoryText();
      }
    } catch (e) {
      print('TTS设置错误: $e');
    }
  }

  Future<void> _speakStoryText() async {
    if (!_isTtsInitialized || _flutterTts == null) return;
    try {
      await _flutterTts!.speak(kStory2Page16Text);
    } catch (e) {
      print('朗读故事文本失败: $e');
    }
  }

  void _initGlowAnimation() {
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.linear,
    ));
    _glowController.repeat();
  }

  // 创建单条光线
  Widget _buildLightRay(double angle, double length, double opacity) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 3,
        height: length,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.yellow.withOpacity(opacity),
              Colors.yellow.withOpacity(opacity * 0.9),
              Colors.yellow.withOpacity(opacity * 0.7),
              Colors.transparent,
            ],
            stops: const [0.0, 0.2, 0.6, 1.0],
          ),
          borderRadius: BorderRadius.circular(1.5),
        ),
      ),
    );
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
              'assets/images/maths/story2/page16.png',
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
          if (kStory2Page16Text.isNotEmpty)
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
                     // 加法挑战按钮（使用指定图标）
           Positioned(
             top: -100,
             left: 30,
            child: GestureDetector(
              onTap: () {
                // 按钮点击事件处理
                print('自定义按钮被点击');
              },
                             child: Stack(
                 alignment: Alignment.center,
                 children: [
                                                                               // 多条金黄色光线旋转效果
                     AnimatedBuilder(
                       animation: _glowAnimation,
                       builder: (context, child) {
                         return Transform.rotate(
                           angle: _glowAnimation.value,
                           child: Stack(
                             alignment: Alignment.center,
                             children: [
                               // 8条主要光线（8个方向）
                               _buildLightRay(0 * 3.14159 / 4, 160, 0.9),      // 上
                               _buildLightRay(1 * 3.14159 / 4, 160, 0.9),      // 右上
                               _buildLightRay(2 * 3.14159 / 4, 160, 0.9),      // 右
                               _buildLightRay(3 * 3.14159 / 4, 160, 0.9),      // 右下
                               _buildLightRay(4 * 3.14159 / 4, 160, 0.9),      // 下
                               _buildLightRay(5 * 3.14159 / 4, 160, 0.9),      // 左下
                               _buildLightRay(6 * 3.14159 / 4, 160, 0.9),      // 左
                               _buildLightRay(7 * 3.14159 / 4, 160, 0.9),      // 左上
                               // 8条次要光线（22.5度偏移）
                               _buildLightRay(0.5 * 3.14159 / 4, 140, 0.7),   // 上偏右
                               _buildLightRay(1.5 * 3.14159 / 4, 140, 0.7),   // 右上偏下
                               _buildLightRay(2.5 * 3.14159 / 4, 140, 0.7),   // 右偏下
                               _buildLightRay(3.5 * 3.14159 / 4, 140, 0.7),   // 右下偏左
                               _buildLightRay(4.5 * 3.14159 / 4, 140, 0.7),   // 下偏左
                               _buildLightRay(5.5 * 3.14159 / 4, 140, 0.7),   // 左下偏上
                               _buildLightRay(6.5 * 3.14159 / 4, 140, 0.7),   // 左偏上
                               _buildLightRay(7.5 * 3.14159 / 4, 140, 0.7),   // 左上偏右
                               // 4条对角线光线
                               _buildLightRay(0.25 * 3.14159 / 4, 120, 0.6),  // 上偏右上
                               _buildLightRay(1.25 * 3.14159 / 4, 120, 0.6),  // 右上偏右
                               _buildLightRay(2.25 * 3.14159 / 4, 120, 0.6),  // 右偏右下
                               _buildLightRay(3.25 * 3.14159 / 4, 120, 0.6),  // 右下偏下
                               _buildLightRay(4.25 * 3.14159 / 4, 120, 0.6),  // 下偏左下
                               _buildLightRay(5.25 * 3.14159 / 4, 120, 0.6),  // 左下偏左
                               _buildLightRay(6.25 * 3.14159 / 4, 120, 0.6),  // 左偏左上
                               _buildLightRay(7.25 * 3.14159 / 4, 120, 0.6),  // 左上偏上
                             ],
                           ),
                         );
                       },
                     ),
                                       // 外层光晕效果
                    Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.yellow.withOpacity(0.2),
                            Colors.yellow.withOpacity(0.05),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.8, 1.0],
                        ),
                      ),
                    ),
                    // 内层光晕效果
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.yellow.withOpacity(0.4),
                            Colors.yellow.withOpacity(0.15),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                    // 图标
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/images/maths/story2/page16_1_1.png',
                        width: 240,
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                    ),
                 ],
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
                      builder: (context) => const Story2Page15(),
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
          // 文本显示区域（底部）
          if (kStory2Page16Text.isNotEmpty)
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
                    kStory2Page16Text,
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
                  '16',
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
