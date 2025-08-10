import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:video_player/video_player.dart';
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
    with WidgetsBindingObserver {
  late FlutterTts _flutterTts;
  late RouteObserver<PageRoute> _routeObserver;
  late VideoPlayerController _videoController;

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

    // 初始化视频背景控制器
    _videoController = VideoPlayerController.asset('assets/images/babyLearning.mp4');
    _videoController.setLooping(true);
    _videoController.setVolume(0.0);
    _videoController.initialize().then((_) {
      if (!mounted) return;
      _videoController.play();
      setState(() {});
    });

    // 延迟1秒后开始滑动动画和语音播放
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        // 开始播放语音
        _speakText('听故事，学数学，一起来吧');
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

    // 停止TTS播放
    try {
      _flutterTts.stop();
    } catch (e) {
      print('停止TTS时出错: $e');
    }

    // 释放视频控制器
    try {
      _videoController.dispose();
    } catch (_) {}

    // 不恢复系统UI，保持全局隐藏设置
    super.dispose();
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用恢复时，重新隐藏系统UI
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      // 恢复视频播放
      if (_videoController.value.isInitialized) {
        _videoController.play();
      }
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // 暂停视频播放
      if (_videoController.value.isInitialized) {
        _videoController.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 背景视频 - 填满整个屏幕，初始化前回退到静态图
          Positioned.fill(child: _buildVideoBackground()),
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
                            'assets/images/maths/math.png',
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // 动画文字已移除
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建视频背景
  Widget _buildVideoBackground() {
    if (_videoController.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: _videoController.value.size.width,
          height: _videoController.value.size.height,
          child: VideoPlayer(_videoController),
        ),
      );
    }
    // 初始化未完成时显示静态背景
    return Image.asset(
      'assets/images/babyLearning.png',
      fit: BoxFit.fill,
      alignment: Alignment.center,
    );
  }
}
