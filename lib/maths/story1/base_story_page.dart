import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BaseStoryPage extends StatefulWidget {
  const BaseStoryPage({super.key});
}

abstract class BaseStoryPageState<T extends BaseStoryPage> extends State<T> {
  bool _isImageLoaded = false;
  String get imagePath;

  @override
  void initState() {
    super.initState();
    
    // 锁定为横屏显示
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    // 预加载图片
    _preloadImage();
  }

  Future<void> _preloadImage() async {
    try {
      // 预加载图片到内存
      await precacheImage(AssetImage(imagePath), context);
      if (mounted) {
        setState(() {
          _isImageLoaded = true;
        });
      }
    } catch (e) {
      print('图片预加载失败: $e');
      if (mounted) {
        setState(() {
          _isImageLoaded = true; // 即使失败也设置为true，让errorBuilder处理
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 优化的页面导航方法
  void navigateToPage(Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        opaque: true, // 确保页面不透明
      ),
    );
  }

  // 返回上一页
  void navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 全屏显示图片
          Positioned.fill(
            child: _isImageLoaded 
              ? Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    print('图片加载错误: $error');
                    return _buildErrorWidget();
                  },
                )
              : _buildLoadingWidget(),
          ),
          ...buildPageContent(),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.blue[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.book,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              '故事页面',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '图片加载失败',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 子类需要实现的方法
  List<Widget> buildPageContent();
} 