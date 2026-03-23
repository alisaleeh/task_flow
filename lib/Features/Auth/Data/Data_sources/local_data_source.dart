import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow/Features/Auth/Data/Models/user_model.dart';

abstract class AuthLocalDataSource {
  /// حفظ بيانات المستخدم والتوكن عند النجاح في تسجيل الدخول
  Future<void> cacheUser(UserModel user, String token);

  /// جلب بيانات المستخدم المخزنة (نحتاجها في الـ Splash Screen)
  Future<UserModel?> getCachedUser();

  /// جلب التوكن فقط (نحتاجه لإرساله مع الـ Headers في الـ ApiService)
  Future<String?> getCachedToken();

  /// مسح البيانات عند تسجيل الخروج
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  // مفاتيح التخزين (Keys)
  static const String _userKey = 'CACHED_USER';
  static const String _tokenKey = 'AUTH_TOKEN';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user, String token) async {
    // نحول الـ Model إلى Map ثم إلى String باستخدام json.encode
    final userJson = json.encode(user.toJson());

    await Future.wait([
      sharedPreferences.setString(_userKey, userJson),
      sharedPreferences.setString(_tokenKey, token),
    ]);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userString = sharedPreferences.getString(_userKey);
    if (userString != null) {
      // نحول النص العائد إلى Map ثم نستخدم factory UserModel.fromJson
      return UserModel.fromJson(json.decode(userString));
    }
    return null;
  }

  @override
  Future<String?> getCachedToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_userKey);
    await sharedPreferences.remove(_tokenKey);
  }
}
