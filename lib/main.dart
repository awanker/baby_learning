import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'maths/math.dart';

// Create a shared RouteObserver instance
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  // 应用启动时立即隐藏系统UI
  WidgetsFlutterBinding.ensureInitialized();

  // 全局设置系统UI隐藏
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));

  // 启动定时器持续监控系统UI
  Timer.periodic(const Duration(milliseconds: 1000), (timer) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _slideController;
  late AnimationController _swingController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _swingAnimation;
  late FlutterTts _flutterTts;
  late RouteObserver<PageRoute> _routeObserver;

  @override
  void initState() {
    super.initState();
    // 添加屏幕方向监听器
    WidgetsBinding.instance.addObserver(this);

    // 初始化TTS
    _initTts();

    // 初始化路由观察器
    _routeObserver = routeObserver;

    // 锁定为横屏显示
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // 初始化滑动动画控制器
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // 初始化摇摆动画控制器
    _swingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // 创建滑动动画 - 从屏幕下方移动到中间偏上位置
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.5), // 从屏幕下方开始
      end: const Offset(0.0, -1.2), // 停在中间偏上位置
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // 创建淡入动画
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeIn,
    ));

    // 创建摇摆动画 - 轻微的左右摇摆
    _swingAnimation = Tween<double>(
      begin: -0.02, // 轻微向左
      end: 0.02, // 轻微向右
    ).animate(CurvedAnimation(
      parent: _swingController,
      curve: Curves.easeInOut,
    ));

    // 延迟1秒后开始滑动动画和语音播放
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        // 开始播放语音
        _speakText('听故事，学数学，一起来吧');

        _slideController.forward().then((_) {
          // 滑动动画完成后开始摇摆动画
          _swingController.repeat(reverse: true);
        });
      }
    });
  }

  // 初始化TTS
  Future<void> _initTts() async {
    _flutterTts = FlutterTts();

    try {
      // 设置语言为中文
      await _flutterTts.setLanguage("zh-CN");
    } catch (e) {
      // 如果中文不可用，使用默认语言
      print('中文TTS不可用，使用默认语言: $e');
    }

    try {
      // 设置语速
      await _flutterTts.setSpeechRate(0.5);

      // 设置音量
      await _flutterTts.setVolume(1.0);

      // 设置音调
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      print('TTS设置错误: $e');
    }
  }

  // 播放语音
  Future<void> _speakText(String text) async {
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print('TTS播放错误: $e');
    }
  }

  @override
  void dispose() {
    // 移除屏幕方向监听器
    WidgetsBinding.instance.removeObserver(this);

    _slideController.dispose();
    _swingController.dispose();

    // 停止TTS播放
    try {
      _flutterTts.stop();
    } catch (e) {
      print('停止TTS时出错: $e');
    }

    // 不恢复系统UI，保持全局隐藏设置
    super.dispose();
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用恢复时，重新隐藏系统UI
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 背景图片 - 填满整个屏幕，包括摄像头区域
          Positioned.fill(
            child: Image.asset(
              'assets/images/babyLearning.png',
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),
          // 内容层 - 直接使用Center，不使用SafeArea
          Center(
            child: Stack(
              children: [
                // 中央播放按钮
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // 播放按钮点击事件 - 跳转到数学页面
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MathPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.0),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/play.jpg',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // 动画文字 - 从屏幕下方飘进，停在中间偏上位置并摇摆
                Center(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: AnimatedBuilder(
                        animation: _swingController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset:
                                Offset(_swingAnimation.value * 50, 0), // 轻微左右摇摆
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Text(
                                '听故事，学数学，一起来吧',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 4.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
