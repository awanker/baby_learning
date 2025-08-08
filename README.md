# Baby Learning App

一个专为婴儿学习设计的Flutter应用。

## 功能特性

### 数学学习页面
- 全屏数学图片展示
- 横屏显示模式
- 沉浸式体验（隐藏系统UI）
- **新增：小鸟飞入动画**
  - 进入数学页面时，一只可爱的小鸟会从屏幕左边飞入
  - 小鸟具有翅膀摆动动画效果
  - 飞行路径带有自然的上下摆动
  - 动画持续4秒，给用户带来愉悦的视觉体验

### 故事功能
- 互动式故事阅读
- 多页面故事内容
- 适合婴儿的简单界面

## 技术实现

### 小鸟动画技术细节
- 使用Flutter的AnimationController实现流畅动画
- 双动画控制器：主飞行动画 + 翅膀摆动动画
- 自定义绘制小鸟图形（身体、头部、眼睛、嘴巴、翅膀、尾巴）
- 动画曲线使用Curves.easeInOut实现自然运动
- 翅膀摆动频率：300毫秒/次

### 权限配置
- Android: 添加了INTERNET和ACCESS_NETWORK_STATE权限
- iOS: 配置了NSAppTransportSecurity允许网络访问

## 运行要求

- Flutter SDK 3.0+
- Dart 2.17+
- Android Studio / VS Code
- 支持横屏显示的设备

## 安装和运行

1. 克隆项目
```bash
git clone [项目地址]
cd baby_learning
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行应用
```bash
flutter run
```

## 项目结构

```
lib/
├── main.dart              # 应用入口
├── maths/
│   ├── math.dart          # 数学页面（包含小鸟动画）
│   └── story1/            # 故事页面
└── assets/
    └── images/            # 图片资源
```

## 动画效果说明

当用户进入数学学习页面时：
1. 页面加载后延迟1秒
2. 小鸟从屏幕左侧开始飞行
3. 飞行过程中翅膀持续摆动
4. 小鸟沿水平方向飞行到屏幕右侧
5. 整个动画过程持续4秒

小鸟动画采用纯代码绘制，不依赖外部图片资源，确保应用的稳定性和加载速度。
