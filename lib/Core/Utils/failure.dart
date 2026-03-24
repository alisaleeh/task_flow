import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

// يمثل فكرة عامة لأي نوع من الخطأ في التطبيق
abstract class Failure {
  final String errorMessage;
  final int statusCode;

  const Failure(this.errorMessage, this.statusCode);

  /// رسالة عربية افتراضية حسب كود الحالة.
  static String _defaultArabicForStatus(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'طلب غير صالح. يرجى التحقق من المدخلات.';
      case 401:
        return 'غير مصرح. يرجى تسجيل الدخول مجدداً.';
      case 403:
        return 'تم رفض الوصول.';
      case 404:
        return 'المورد غير موجود.';
      case 413:
        return 'حجم البيانات المرسلة كبير جداً. يرجى تقليل حجم الصور أو عددها والمحاولة مرة أخرى.';
      case 422:
        return 'تأكد من صحة البيانات المرسلة.';
      case 500:
      case 502:
      case 503:
        return 'خطأ في الخادم. يرجى المحاولة لاحقاً.';
      default:
        return 'لم يتمكن الخادم من معالجة طلبك. يرجى المحاولة لاحقاً.';
    }
  }

  /// يرجّع رسالة مناسبة للمستخدم بالعربية فقط
  static String toUserFacingMessage(int statusCode, String? rawMessage) {
    final trimmed = rawMessage?.trim() ?? '';
    if (trimmed.isEmpty) return _defaultArabicForStatus(statusCode);
    
    final hasArabic = trimmed.runes.any((r) => r >= 0x0600 && r <= 0x06FF);
    if (hasArabic) {
      const maxLength = 300;
      return trimmed.length <= maxLength
          ? trimmed
          : '${trimmed.substring(0, maxLength)}...';
    }
    return _defaultArabicForStatus(statusCode);
  }
}

/// Enum to categorize error types for smarter error handling.
enum FailureCategory {
  timeout,
  certificate,
  network,
  authentication,
  authorization,
  notFound,
  validation,
  server,
  cancelled,
  unknown,
}

// كلاس مخصص للتعامل مع أخطاء الشبكة أو الـ API
class ServerFailure extends Failure {
  final FailureCategory category;
  
  const ServerFailure(
    super.errorMessage,
    super.statusCode, {
    this.category = FailureCategory.unknown,
  });

  factory ServerFailure.fromDioError(DioException dioException) {
    final uri = dioException.requestOptions.uri;
    final method = dioException.requestOptions.method;
    log('[$method] $uri failed: ${dioException.message}', error: dioException);

    if (dioException.error is HttpException) {
      return const ServerFailure(
        'تعذر استكمال الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت والمحاولة لاحقًا.',
        608,
        category: FailureCategory.network,
      );
    }

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
          'انتهت مهلة الاتصال. يرجى التحقق من جودة الإنترنت.',
          600,
          category: FailureCategory.timeout,
        );
      case DioExceptionType.badCertificate:
        return const ServerFailure(
          'شهادة أمان غير صالحة.',
          603,
          category: FailureCategory.certificate,
        );
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response?.statusCode ?? 604,
          dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return const ServerFailure(
          'تم إلغاء طلب الاتصال بالخادم.',
          605,
          category: FailureCategory.cancelled,
        );
      case DioExceptionType.connectionError:
        return const ServerFailure(
          'تعذر الاتصال بالشبكة، يرجى التحقق من اتصال الإنترنت.',
          606,
          category: FailureCategory.network,
        );
      case DioExceptionType.unknown:
      if (dioException.error is SocketException) {
          return const ServerFailure(
            'انقطع الاتصال أثناء إرسال البيانات. تحقق من اتصال الإنترنت وحاول مرة أخرى.',
            607,
            category: FailureCategory.network,
          );
        }
        return ServerFailure(
          Failure.toUserFacingMessage(607, dioException.message),
          607,
          category: FailureCategory.unknown,
        );
    }
  }

  // 👈 التعديل هنا: إضافة المنطق لتحديد الـ Category بناءً على كود الحالة
  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    String? rawMessage;

    if (response is Map) {
      final rootMessage = response['message'] ?? response['error'];
      final data = response['data'];
      final dataMessage = data is Map ? (data['message'] ?? data['error'])?.toString() : null;
      final extracted = rootMessage?.toString() ?? dataMessage;
      if (extracted != null && extracted.trim().isNotEmpty) {
        rawMessage = extracted.trim();
      }
    } else if (response is String && response.trim().isNotEmpty) {
      final trimmed = response.trim();
      final isHtml = trimmed.toLowerCase().contains('<html') ||
          trimmed.toLowerCase().contains('<title>') ||
          trimmed.toLowerCase().contains('request entity too large');
      if (!isHtml) rawMessage = trimmed;
    }

    final errorMessage = Failure.toUserFacingMessage(statusCode, rawMessage);
    
    // تحديد الفئة المناسبة هندسياً
    FailureCategory determinedCategory = FailureCategory.unknown;
    if (statusCode == 401) {
      determinedCategory = FailureCategory.authentication;
    } else if (statusCode == 403) {
      determinedCategory = FailureCategory.authorization;
    } else if (statusCode == 404) {
      determinedCategory = FailureCategory.notFound;
    } else if (statusCode == 422 || statusCode == 400) {
      determinedCategory = FailureCategory.validation;
    } else if (statusCode >= 500) {
      determinedCategory = FailureCategory.server;
    }

    return ServerFailure(
      errorMessage, 
      statusCode, 
      category: determinedCategory,
    );
  }
}

/// استثناء مخصص لفشل العمليات.
class AppException implements Exception {
  final Failure failure;
  AppException(this.failure);

  @override
  String toString() => 'AppException: ${failure.errorMessage}';
}

// 👈 التعديل الأهم: دالة الـ Retry أصبحت ذكية وتحتوي على فاصل زمني (Delay)
Future<T> dioRequest<T>(
  Future<T> Function() request, {
  int retryCount = 0,
}) async {
  int attempts = 0;
  while (true) {
    try {
      return await request();
    } on DioException catch (error) {
      final isRetryable = _isRetryableError(error);
      
      if (isRetryable && attempts < retryCount) {
        attempts++;
        log('Retry attempt $attempts for failed request...');
        // تأخير زمني يتصاعد مع كل محاولة فاشلة (Exponential Backoff)
        await Future.delayed(Duration(seconds: 2 * attempts)); 
        continue;
      }
      throw AppException(ServerFailure.fromDioError(error));
    }
  }
}

// 👈 دالة مساعدة لتحديد ما إذا كان الخطأ يستحق إعادة المحاولة أصلاً
bool _isRetryableError(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.connectionError) {
    return true; // أخطاء الشبكة والوقت تستحق المحاولة
  }
  
  if (error.response != null && error.response!.statusCode != null) {
    final statusCode = error.response!.statusCode!;
    return statusCode >= 500; // أخطاء الخادم تستحق المحاولة
  }
  
  return false; // أخطاء 4xx (مثل 400، 401، 404) لا تستحق المحاولة لأنها لن تنجح
}