import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow/Core/Utils/service_locator.dart'; // 👈 استيراد الـ getIt للوصول للذاكرة

class ApiService {
  static const baseURL = 'https://task-managment-system.code-nest.cloud/';
  final Dio dio;

  ApiService({required this.dio});

  // 🛠️ دالة مساعدة ذكية لتجهيز الـ Headers أوتوماتيكياً وسحب التوكن
  Future<Map<String, dynamic>> _getHeaders({bool isFormData = false}) async {
    Map<String, dynamic> headers = {
      'Accept': 'application/json',
    };

    // 🔥 إذا كان FormData، لا نضع Content-Type، مكتبة ديو ستقوم بذلك
    if (!isFormData) {
      headers['Content-Type'] = 'application/json';
    }

    // 👈 سحب التوكن من الذاكرة المحلية مباشرة
    final prefs = getIt<SharedPreferences>();
    // ⚠️ تنبيه: تأكد أن كلمة 'token' هنا هي نفس الكلمة التي حفظت بها التوكن في شاشة تسجيل الدخول
    final String? token = prefs.getString('AUTH_TOKEN'); 

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // ✅ دالة GET
  Future<dynamic> getData({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    // تم حذف تمرير التوكن اليدوي من هنا
  }) async {
    try {
      final headers = await _getHeaders(); // 👈 استدعاء السحر هنا

      final response = await dio.get(
        "$baseURL$endpoint",
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      return response.data;
    } catch (e) {
      log('API GET error: $e');
      rethrow;
    }
  }

  // ✅ دالة POST
  Future<dynamic> postData({
    required String endpoint,
    required dynamic data, 
    bool isFormData = false, 
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) async {
    try {
      final headers = await _getHeaders(isFormData: isFormData);

      final response = await dio.post(
        "$baseURL$endpoint",
        data: data,
        options: Options(
          headers: headers,
          receiveTimeout: receiveTimeout ?? const Duration(seconds: 60),
          sendTimeout: sendTimeout ?? const Duration(seconds: 60),
        ),
      );
      return response.data;
    } catch (e) {
      log('API POST error: $e');
      rethrow;
    }
  }

  // ✅ دالة PUT
  Future<dynamic> putData({
    required String endpoint,
    required dynamic data,
    bool isFormData = false,
  }) async {
    try {
      final headers = await _getHeaders(isFormData: isFormData);

      final response = await dio.put(
        "$baseURL$endpoint",
        data: data,
        options: Options(
          headers: headers,
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );
      return response.data;
    } catch (e) {
      log('API PUT error: $e');
      rethrow;
    }
  }

  // ✅ دالة DELETE
  Future<dynamic> deleteData({
    required String endpoint,
    dynamic data, // أضفنا data لأن الـ DELETE أحياناً يقبل Body
  }) async {
    try {
      final headers = await _getHeaders();

      final response = await dio.delete(
        "$baseURL$endpoint",
        data: data,
        options: Options(
          headers: headers,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      return response.data;
    } catch (e) {
      log('API DELETE error: $e');
      rethrow;
    }
  }
}