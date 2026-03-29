import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow/Features/Auth/Data/Models/user_model.dart';

abstract class AuthLocalDataSource {
  /// حفظ بيانات المستخدم والتوكن عند النجاح في تسجيل الدخول
  Future<void> cacheUser(UserModel user, String token);

  /// جلب بيانات المستخدم المخزنة بالكامل
  Future<UserModel?> getCachedUser();

  /// جلب التوكن فقط
  Future<String?> getCachedToken();

  // 🚀 إضافات جديدة لجلب الاسم بسرعة
  Future<String?> getCachedFirstName();
  Future<String?> getCachedLastName();

  /// مسح البيانات عند تسجيل الخروج
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  // مفاتيح التخزين (Keys)
  static const String _userKey = 'CACHED_USER';
  static const String _tokenKey = 'AUTH_TOKEN';
  // 🚀 مفاتيح جديدة للاسم
  static const String _firstNameKey = 'FIRST_NAME';
  static const String _lastNameKey = 'LAST_NAME';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user, String token) async {
    final userJson = json.encode(user.toJson());

    // 🚀 نستخدم Future.wait لتنفيذ كل عمليات الحفظ في نفس اللحظة (أداء أسرع)
    await Future.wait([
      sharedPreferences.setString(_userKey, userJson),
      sharedPreferences.setString(_tokenKey, token),
      // تأكد أن UserModel يحتوي على خصائص firstName و lastName
      // استخدمنا الإسناد الافتراضي '' لتجنب حفظ null إذا كان الاسم غير متوفر
      sharedPreferences.setString(_firstNameKey, user.firstname),
      sharedPreferences.setString(_lastNameKey, user.lastname),
    ]);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userString = sharedPreferences.getString(_userKey);
    if (userString != null) {
      return UserModel.fromJson(json.decode(userString));
    }
    return null;
  }

  @override
  Future<String?> getCachedToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  // 🚀 دوال الجلب السريعة للاسم
  @override
  Future<String?> getCachedFirstName() async {
    return sharedPreferences.getString(_firstNameKey);
  }

  @override
  Future<String?> getCachedLastName() async {
    return sharedPreferences.getString(_lastNameKey);
  }

  @override
  Future<void> clearCache() async {
    // 🚀 تنظيف شامل لكل المفاتيح دفعة واحدة
    await Future.wait([
      sharedPreferences.remove(_userKey),
      sharedPreferences.remove(_tokenKey),
      sharedPreferences.remove(_firstNameKey),
      sharedPreferences.remove(_lastNameKey),
    ]);
  }
}
