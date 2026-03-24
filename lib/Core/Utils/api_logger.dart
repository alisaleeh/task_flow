import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiLoggerInterceptor extends Interceptor {
  // 🟢 1. تتنفذ قبل أن يخرج الطلب من التطبيق إلى السيرفر
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('🌐 [API Request] ${options.method.toUpperCase()} ${options.uri}');
    debugPrint('📦 [Headers] ${options.headers}');
    debugPrint('📤 [Body] ${options.data}');
    super.onRequest(options, handler);
  }

  // ✅ 2. تتنفذ عندما يعود الرد بنجاح (200 OK) من السيرفر
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ [API Response] [${response.statusCode}] ${response.requestOptions.uri}');
    debugPrint('📥 [Data] ${response.data}');
    super.onResponse(response, handler);
  }

  // ❌ 3. تتنفذ عندما يغضب السيرفر ويرمي خطأ (مثل الـ 400 الذي يواجهك!)
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ [API Error] [${err.response?.statusCode}] ${err.requestOptions.uri}');
    debugPrint('🩸 [Error Message] ${err.message}');
    debugPrint('🩸 [Error Response Body] ${err.response?.data}'); // 👈 هذا السطر سيكشف لنا سر الـ 400!
    super.onError(err, handler);
  }
}