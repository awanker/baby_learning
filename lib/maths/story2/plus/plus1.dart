import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../page16.dart' show Story2Page16;
import '../global_state.dart'; // 导入全局状态管理
import 'dart:math'; // Added for Random

class Plus1Page extends StatefulWidget {
  const Plus1Page({super.key});

  @override
  State<Plus1Page> createState() => _Plus1PageState();
}

class _Plus1PageState extends State<Plus1Page> {
  late int _addend1;
  late int _addend2;
  late int _correctAnswer;
  final TextEditingController _answerController = TextEditingController();
  late FlutterTts _flutterTts;
  
  // 新增：跟踪答题情况
  int _consecutiveCorrect = 0;  // 连续答对次数
  int _totalCorrect = 0;        // 累计答对次数
  bool _showPlus2Button = false; // 是否显示plus2按钮

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
    _initTts();
    // 立即停止任何正在播放的语音
    _flutterTts.stop();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _initTts() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("zh-CN");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  void _generateNewQuestion() {
    _addend1 = _generateRandomNumber();
    _addend2 = _generateRandomNumber();
    _correctAnswer = _addend1 + _addend2;
    _answerController.clear();
    
    // 检查是否应该显示plus2按钮
    _checkShowPlus2Button();
  }

  int _generateRandomNumber() {
    // 使用Random类生成更好的随机数，允许相同数字出现
    return Random().nextInt(10) + 2; // 1到10的随机数
  }

  void _checkAnswer() {
    if (_answerController.text.isEmpty) {
      _speakMessage('请输入答案！');
      return;
    }

    int userAnswer = int.tryParse(_answerController.text) ?? -1;
    
    if (userAnswer == _correctAnswer) {
      _consecutiveCorrect++;
      _totalCorrect++;
      
      // 检查是否达到显示plus2按钮的条件
      if (_consecutiveCorrect >= 10 || _totalCorrect >= 20) { 
        setState(() {
          _showPlus2Button = true;
        });
        // 设置全局状态：已获得加法勋章
        Story2GlobalState.instance.grantAdditionMedal();
        _speakMessage('真棒！过关了，获得一枚加法勋章');
      } else {
        _speakMessage('正确！真棒！');
      }
      
      // 2秒后自动生成新题目
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _generateNewQuestion();
          });
        }
      });
    } else {
      _consecutiveCorrect = 0; // 答错时重置连续答对次数
      _speakMessage('错误，再试一次！');
    }
  }

  void _speakMessage(String message) async {
    await _flutterTts.speak(message);
  }

  void _checkShowPlus2Button() {
    if (_consecutiveCorrect >= 10 || _totalCorrect >= 20) {
      setState(() {
        _showPlus2Button = true;
      });
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
              'assets/images/maths/story2/plus/plus1.png',
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),

          // 返回按钮
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  print('返回按钮被点击'); // 添加调试信息
                  _speakMessage('正在返回...'); // 添加语音反馈
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Story2Page16(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/maths/story2/plus/plus3.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // 加法勋章（达到条件时显示）- 移到右上方
          if (_showPlus2Button)
            Positioned(
              top: 10,
              right: 80,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 2),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 2 * 3.14159, // 完整旋转一圈
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // TODO: 跳转到plus2页面
                          _speakMessage('即将进入下一关！');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            'assets/images/maths/story2/plus/plus2.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // 加法题目区域 - 使用滚动视图避免溢出，调整位置避免覆盖返回按钮
          Positioned(
            top: 100, // 从顶部100像素开始，避免覆盖返回按钮
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 200, // 调整最小高度
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 移除顶部留白，因为已经通过Positioned的top调整了
                      
                      // 题目显示区域
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 题目显示
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '$_addend1 + $_addend2 = ',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                // 答案输入框
                                Container(
                                  width: 80,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.blue, width: 2),
                                  ),
                                  child: TextField(
                                    controller: _answerController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '?',
                                      hintStyle: TextStyle(
                                        fontSize: 24,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    onSubmitted: (_) => _checkAnswer(),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // 提交按钮
                            ElevatedButton(
                              onPressed: _checkAnswer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.withOpacity(0.8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                '提交答案',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40), // 增加间距，让过关按钮更靠上
                      
                      const Spacer(), // 添加弹性空间，将过关按钮推到中间偏上
                      
                      const SizedBox(height: 20), // 底部留白
                    ],
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
