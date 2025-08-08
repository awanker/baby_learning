import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../main.dart';
import 'story1/cover.dart';



class MathPage extends StatefulWidget {
  const MathPage({super.key});

  @override
  State<MathPage> createState() => _MathPageState();
}

// 提取常量小部件以提高性能
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

// 提取返回按钮小部件
class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
          (route) => false,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

// 小鸟头像组件（复用与解耦）
class _BirdAvatar extends StatelessWidget {
  const _BirdAvatar();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_MathPageState>();
    if (state == null) return const SizedBox.shrink();

    final wingValue = state._wingAnimation.value;
    final imageIndex = (wingValue * (state.birdImages.length - 1))
        .round()
        .clamp(0, state.birdImages.length - 1);

    return ClipOval(
      child: state._isImagesLoaded.value
          ? Image(
              image: state._imageCache[state.birdImages[imageIndex]]!,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              gaplessPlayback: true,
            )
          : const SizedBox.shrink(),
      clipBehavior: Clip.antiAlias,
    );
  }
}

// 提取故事按钮小部件
class _StoryButton extends StatelessWidget {
  const _StoryButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Story1CoverPage(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.book,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              '故事',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MathPageState extends State<MathPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // 使用 late 来延迟初始化动画控制器
  late final AnimationController _birdAnimationController;
  late final AnimationController _wingAnimationController;
  late final Animation<Offset> _birdAnimation;
  late final Animation<double> _birdRotationAnimation;
  late final Animation<double> _wingAnimation;
  
  // 使用 ValueNotifier 管理状态
  final ValueNotifier<bool> _isImagesLoaded = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isAnimationReady = ValueNotifier<bool>(false);
  
  // 图片缓存
  final Map<String, ImageProvider> _imageCache = {};

  // 小鸟图片列表 - 用于翅膀摆动动画
  final List<String> birdImages = [
    'assets/images/maths/bird1.png', // 翅膀收起
    'assets/images/maths/bird2.png', // 翅膀半开
    'assets/images/maths/bird3.png', // 翅膀全开
  ];

  // 处理小鸟动画状态变化
  void _handleBirdAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // 当小鸟飞到屏幕右边时，重置位置并重新开始
      if (mounted) {
        _birdAnimationController
          ..reset()
          ..forward();
      }
    }
  }

  // 处理翅膀动画状态变化
  void _handleWingAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
      if (mounted && _isAnimationReady.value) {
        _wingAnimationController.reverse();
      }
    }
  }

  // 预加载所有图片资源
  Future<void> _preloadImages() async {
    if (_isImagesLoaded.value) return;

    try {
      final imagesToPreload = [
        'assets/images/math.png',
        ...birdImages,
      ];

      for (final imagePath in imagesToPreload) {
        try {
          debugPrint('正在加载图片: $imagePath');
          final imageProvider = AssetImage(imagePath);
          _imageCache[imagePath] = imageProvider;
          
          // 在后台线程预加载图片
          await precacheImage(imageProvider, context);
          debugPrint('图片加载成功: $imagePath');
        } catch (e) {
          debugPrint('图片加载失败: $imagePath, 错误: $e');
          // 继续加载其他图片
        }
      }
      
      if (mounted) {
        _isImagesLoaded.value = true;
        _isAnimationReady.value = true;
        debugPrint('所有图片预加载完成');
      }
    } catch (e) {
      debugPrint('预加载图片时发生错误: $e');
      if (mounted) {
        _isImagesLoaded.value = false;
        _isAnimationReady.value = false;
      }
    }
  }

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

    // 初始化动画控制器
    _birdAnimationController = AnimationController(
      duration: const Duration(seconds: 8), // 增加飞行时间，让小鸟飞得更慢
      vsync: this,
    );
    _wingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // 添加动画状态监听
    _birdAnimationController.addStatusListener(_handleBirdAnimationStatus);
    _wingAnimationController.addStatusListener(_handleWingAnimationStatus);

    // 创建小鸟位置动画 - 从屏幕右边飞入到左边，带有轻微的上下摆动
    _birdAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0.2), // 从屏幕右边开始
      end: const Offset(-1.5, 0.2), // 飞到屏幕左边
    ).animate(CurvedAnimation(
      parent: _birdAnimationController,
      curve: Curves.easeInOut,
    ));

    // 创建小鸟旋转动画 - 模拟飞行时的摆动，向左飞行时稍微向左倾斜
    _birdRotationAnimation = Tween<double>(
      begin: 0.1, // 稍微向左倾斜
      end: -0.1, // 飞行过程中轻微摆动
    ).animate(CurvedAnimation(
      parent: _birdAnimationController,
      curve: Curves.easeInOut,
    ));

    // 创建翅膀摆动动画
    _wingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _wingAnimationController,
      curve: Curves.easeInOut,
    ));

    // 预加载图片资源
    _preloadImages().then((_) {
      // 图片加载完成后启动动画
      if (mounted) {
        _startAnimations();
      }
    });
  }

  // 启动所有动画
  Future<void> _startAnimations() async {
    if (!_isAnimationReady.value || !mounted) return;

    try {
      // 延迟1秒后开始动画
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;

      // 启动小鸟动画
      await _birdAnimationController.forward();
      
      if (!mounted) return;

      // 启动翅膀动画
      _wingAnimationController.repeat(reverse: true);
    } catch (e) {
      debugPrint('Error starting animations: $e');
      // 在生产环境中可以添加错误报告
    }
  }

  // 停止所有动画
  void _stopAnimations() {
    _birdAnimationController.stop();
    _wingAnimationController.stop();
  }

  // 暂停所有动画
  void _pauseAnimations() {
    if (_birdAnimationController.isAnimating) {
      _birdAnimationController.stop();
    }
    if (_wingAnimationController.isAnimating) {
      _wingAnimationController.stop();
    }
  }

  // 恢复所有动画
  void _resumeAnimations() {
    if (!_birdAnimationController.isAnimating && _isAnimationReady.value) {
      _birdAnimationController.forward();
    }
    if (!_wingAnimationController.isAnimating && _isAnimationReady.value) {
      _wingAnimationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    // 移除状态监听器
    _isImagesLoaded.dispose();
    _isAnimationReady.dispose();

    // 移除动画状态监听器
    _birdAnimationController.removeStatusListener(_handleBirdAnimationStatus);
    _wingAnimationController.removeStatusListener(_handleWingAnimationStatus);

    // 移除屏幕方向监听器
    WidgetsBinding.instance.removeObserver(this);

    // 停止并释放动画控制器
    _stopAnimations();
    _birdAnimationController.dispose();
    _wingAnimationController.dispose();

    // 清理图片缓存
    _imageCache.clear();

    // 不恢复系统UI，保持全局隐藏设置
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        // 当应用恢复时，重新隐藏系统UI并恢复动画
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
        _resumeAnimations();
        break;
      case AppLifecycleState.paused:
        // 当应用暂停时，暂停动画以节省资源
        _pauseAnimations();
        break;
      case AppLifecycleState.inactive:
        // 当应用不活跃时，暂停动画
        _pauseAnimations();
        break;
      case AppLifecycleState.detached:
        // 当应用分离时，停止动画
        _stopAnimations();
        break;
      default:
        break;
    }
  }

  // 提取小鸟动画构建方法以提高可维护性
  Widget _buildBirdAnimation(BuildContext context) {
    // 计算小鸟的垂直摆动 - 使用缓存值
    final wingValue = _wingAnimation.value;
    final verticalSwing = 0.1 * (0.5 + 0.5 * wingValue);
    final currentY = _birdAnimation.value.dy + verticalSwing * 0.1;

    // 根据翅膀摆动动画选择不同的图片 - 优化计算
    final imageIndex = (_wingAnimation.value * (birdImages.length - 1))
        .round()
        .clamp(0, birdImages.length - 1);

    // 缓存 MediaQuery 的值以避免重复访问
    final size = MediaQuery.of(context).size;

    // 使用绝对定位而不是Transform.translate
    return Positioned(
      left: size.width * _birdAnimation.value.dx - 10, // 减去一半宽度以居中
      top: size.height * currentY - 10, // 减去一半高度以居中
      child: Transform.rotate(
        angle: _birdRotationAnimation.value + wingValue * 0.1,
        child: SizedBox(
          width: 120,
          height: 120,
          child: _BirdAvatar(),
        ),
      ),
    );
  }

  // 提取背景图片构建方法
  Widget _buildBackground() {
    return RepaintBoundary(
      child: ValueListenableBuilder<bool>(
        valueListenable: _isImagesLoaded,
        builder: (context, isLoaded, _) {
          if (!isLoaded) {
            return const _LoadingIndicator();
          }

          final imageProvider = _imageCache['assets/images/math.png'];
          if (imageProvider == null) {
            debugPrint('背景图片未找到在缓存中');
            return Container(
              color: Colors.blue,
              child: const Center(
                child: Text(
                  '背景图片加载失败',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            );
          }
          return Image(
            image: imageProvider,
            fit: BoxFit.fill,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('背景图片显示错误: $error');
              return Container(
                color: Colors.red,
                child: const Center(
                  child: Text(
                    '图片显示错误',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 提取UI控件层构建方法
  Widget _buildUIControls() {
    return RepaintBoundary(
      child: Stack(
        children: const [
          Positioned(
            top: 50,
            left: 20,
            child: _BackButton(),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: _StoryButton(),
          ),
        ],
      ),
    );
  }

  // 提取动画层构建方法
  Widget _buildAnimationLayer(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isAnimationReady,
      builder: (context, isReady, _) {
        if (!isReady) return const SizedBox.shrink();

        return RepaintBoundary(
          child: AnimatedBuilder(
            animation: _birdAnimationController,
            builder: (context, _) {
              return AnimatedBuilder(
                animation: _wingAnimationController,
                builder: (context, _) {
                  return Stack(
                    children: [
                      _buildBirdAnimation(context),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 背景层需要填满 Stack
            Positioned.fill(child: _buildBackground()),

            // 动画层
            _buildAnimationLayer(context),

            // UI控件层
            _buildUIControls(),
          ],
        ),
      ),
    );
  }
}
