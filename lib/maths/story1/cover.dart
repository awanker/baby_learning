import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../math.dart';
import 'page1.dart';

class Story1CoverPage extends StatefulWidget {
  const Story1CoverPage({super.key});

  @override
  State<Story1CoverPage> createState() => _Story1CoverPageState();
}

class _Story1CoverPageState extends State<Story1CoverPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // 添加屏幕方向监听器
    WidgetsBinding.instance.addObserver(this);

    // 锁定为横屏显示
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // 移除屏幕方向监听器
    WidgetsBinding.instance.removeObserver(this);
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
          // 全屏显示故事封面图片 - 填满整个屏幕，包括摄像头区域
          Positioned.fill(
            child: Image.asset(
              'assets/images/maths/story1/cover.png',
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),

          // 返回数学页按钮（math.png）
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MathPage(),
                  ),
                  (route) => false,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 32,
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
                      builder: (context) => const Story1Page1(),
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

        ],
      ),
    );
  }
}
