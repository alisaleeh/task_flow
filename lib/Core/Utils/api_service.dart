import 'dart:developer';
import 'package:dio/dio.dart';

class ApiService {
  static const baseURL = 'https://api.shihal.net/';
  final Dio dio;

  ApiService({required this.dio});

  // ✅ دالة GET
  Future<dynamic> getData({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      Map<String, dynamic> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

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

  // ✅ دالة POST المصححة
  Future<dynamic> postData({
    required String endpoint,
    required dynamic data, // 🔥 يستقبل Dynamic لقبول FormData
    String? token,
    bool isFormData = false, // 🔥 للتحكم في نوع البيانات
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
      };

      // 🔥 إذا كان FormData، لا نضع Content-Type، ديو سيقوم بذلك
      if (!isFormData) {
        headers['Content-Type'] = 'application/json';
      }

      // إضافة التوكن
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

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
    String? token,
    bool isFormData = false,
  }) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
      };

      if (!isFormData) {
        headers['Content-Type'] = 'application/json';
      }

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

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
    String? token,
  }) async {
    try {
      Map<String, dynamic> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await dio.delete(
        "$baseURL$endpoint",
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