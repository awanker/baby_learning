// Story2 全局状态管理
class Story2GlobalState {
  // 私有构造函数，确保单例模式
  Story2GlobalState._();
  
  // 单例实例
  static final Story2GlobalState _instance = Story2GlobalState._();
  
  // 获取单例实例的静态方法
  static Story2GlobalState get instance => _instance;
  
  // 加法勋章状态
  // true: 已获得加法勋章
  // false: 未获得加法勋章
  bool _hasAdditionMedal = false;
  
  // 获取加法勋章状态
  bool get hasAdditionMedal => _hasAdditionMedal;
  
  // 设置加法勋章状态
  set hasAdditionMedal(bool value) {
    _hasAdditionMedal = value;
  }
  
  // 授予加法勋章
  void grantAdditionMedal() {
    _hasAdditionMedal = true;
  }
  
  // 重置加法勋章状态
  void resetAdditionMedal() {
    _hasAdditionMedal = false;
  }
  
  // 检查是否已获得加法勋章
  bool isAdditionMedalEarned() {
    return _hasAdditionMedal;
  }
} 