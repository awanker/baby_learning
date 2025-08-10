import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../page16.dart';
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
    return Random().nextInt(10) + 1; // 1到10的随机数
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
      if (_consecutiveCorrect >= 5 || _totalCorrect >= 10) {
        setState(() {
          _showPlus2Button = true;
        });
        _speakMessage('真棒！过关了');
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
    if (_consecutiveCorrect >= 5 || _totalCorrect >= 10) {
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
            top: -40,
            left: -30,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                'assets/images/maths/math.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 加法题目区域
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
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
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      // 答案输入框
                      Container(
                        width: 120,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.transparent, width: 3),
                        ),
                        child: TextField(
                          controller: _answerController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '?',
                            hintStyle: TextStyle(
                              fontSize: 32,
                              color: Colors.grey,
                            ),
                          ),
                          onSubmitted: (_) => _checkAnswer(),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // 提交按钮
                  ElevatedButton(
                    onPressed: _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      '提交答案',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Plus2按钮（达到条件时显示）
                  if (_showPlus2Button)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          // TODO: 跳转到plus2页面
                          _speakMessage('即将进入下一关！');
                        },
                        child: Image.asset(
                          'assets/images/maths/story2/plus/plus2.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  
                  // Removed visual result display
                  
                  // Removed new question button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
