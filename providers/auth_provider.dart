import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;

  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._apiService);

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get userName => _user?.fullName ?? _user?.username ?? 'Guest';
  String? get userId => _user?.id;

  // 从本地存储恢复登录状态
  Future<void> initAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (userJson != null && isLoggedIn) {
        final userData = User.fromJson({
          'id': prefs.getString('userId'),
          'username': prefs.getString('username'),
          'fullName': prefs.getString('fullName'),
          'email': prefs.getString('email'),
        });

        _user = userData;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('恢复登录状态失败: $e');
      await logout();
    }
  }

  // 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // 设置错误信息
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // 清除错误信息
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // 保存用户信息到本地存储
  Future<void> _saveUserToStorage() async {
    if (_user == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final userMap = _userToJson(_user!);
      await prefs.setString('user', userMap);
      await prefs.setString('userId', _user!.id ?? '');
      await prefs.setString('username', _user!.username);
      await prefs.setString('fullName', _user!.fullName ?? '');
      await prefs.setString('email', _user!.email ?? '');
      await prefs.setBool('isLoggedIn', true);
    } catch (e) {
      debugPrint('保存用户信息失败: $e');
    }
  }

  // 用户注册
  Future<bool> register({
    required String username,
    required String password,
    String? fullName,
    String? email,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final userData = await _apiService.register(
        username,
        password,
        fullName: fullName,
        email: email,
      );

      _user = User.fromJson(userData);
      await _saveUserToStorage();
      notifyListeners();

      return true;
    } catch (e) {
      _setError('注册失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 用户登录 - 完全重写以匹配前端逻辑
  Future<bool> login(String username, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      // 1. 先登录 - 可能只是返回成功状态
      await _apiService.login(username, password);

      // 2. 登录成功后获取用户信息
      User user;
      try {
        final userData = await _apiService.getUserByUsername(username);
        user = User.fromJson(userData);
      } catch (e) {
        // 如果通过用户名获取失败，尝试其他方式获取用户信息
        debugPrint('通过用户名获取用户信息失败: $e');
        // 创建一个基本的用户对象
        user = User(
          username: username,
          fullName: username,
        );
      }

      _user = user;
      await _saveUserToStorage();
      notifyListeners();

      return true;
    } catch (e) {
      _setError('登录失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 通过ID获取用户信息
  Future<void> fetchUserById(String userId) async {
    try {
      final userData = await _apiService.getUserById(userId);
      _user = User.fromJson(userData);
      await _saveUserToStorage();
      notifyListeners();
    } catch (e) {
      debugPrint('获取用户信息失败: $e');
    }
  }

  // 更新密码
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_user?.id == null) {
        throw Exception('用户未登录');
      }

      await _apiService.updatePassword(_user!.id!, oldPassword, newPassword);
      return true;
    } catch (e) {
      _setError('密码修改失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 更新个人资料
  Future<bool> updateProfile(String fullName, String email) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_user?.id == null) {
        throw Exception('用户未登录');
      }

      final updatedUserData = await _apiService.updateProfile(_user!.id!, fullName, email);
      _user = User.fromJson(updatedUserData);
      await _saveUserToStorage();
      notifyListeners();

      return true;
    } catch (e) {
      _setError('更新资料失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 用户登出
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.remove('userId');
      await prefs.remove('username');
      await prefs.remove('fullName');
      await prefs.remove('email');
      await prefs.remove('isLoggedIn');
    } catch (e) {
      debugPrint('清除本地数据失败: $e');
    }

    _user = null;
    _error = null;
    notifyListeners();
  }

  // 检查登录状态
  bool checkAuthStatus() {
    return _user != null;
  }

  // 临时转换函数
  String _userToJson(User user) {
    return '{"id":"${user.id}","username":"${user.username}","fullName":"${user.fullName ?? ''}","email":"${user.email ?? ''}"}';
  }
}

