import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/Features/Auth/Presentation/Manager/login_cubit/login_cubit.dart';
import 'package:taskflow/Features/Auth/Presentation/Manager/register_cubit/register_cubit.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';
import 'package:taskflow/Features/Task/Presentation/Manager/cubit/create_task_cubit.dart';

/// هذا الملف يحتوي على اختصارات (Extensions) قوية جداً لـ BuildContext
/// لتقليل الـ Boilerplate code وجعل الكود نظيفاً ومقروءاً.
extension ContextHelper on BuildContext {
  // =========================================
  // 1️⃣ سحر التنقل (Navigation) 🧭
  // =========================================

  /// الانتقال لشاشة جديدة
  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  /// استبدال الشاشة الحالية بشاشة جديدة (مثل الانتقال من Splash إلى Home)
  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  /// الانتقال لشاشة جديدة وحذف كل الشاشات السابقة (مثل تسجيل الخروج)
  void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// العودة للخلف مع إمكانية إرجاع بيانات
  void pop([dynamic result]) {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop(result);
    }
  }
// الانتقال مع مسح الشاشات السابقة باستخدام (Route مخصص / حركة سينمائية)
  void pushAndRemoveUntilRoute(Route route) {
    Navigator.of(this).pushAndRemoveUntil(route, (route) => false);
  }

  // الانتقال مع استبدال الشاشة الحالية باستخدام (Route مخصص / حركة سينمائية)
  void pushReplacementRoute(Route route) {
    Navigator.of(this).pushReplacement(route);
  }
  // الانتقال لشاشة مع حركة سينمائية (وانتظار النتيجة)
  Future<dynamic> pushRoute(Route route) {
    return Navigator.of(this).push(route);
  }
  // =========================================
  // 2️⃣ سحر المقاسات (MediaQuery) 📏
  // =========================================

  /// ارتفاع الشاشة بالكامل
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// عرض الشاشة بالكامل
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// المسافة الآمنة من الأعلى (Status bar)
  double get topPadding => MediaQuery.paddingOf(this).top;

  /// المسافة الآمنة من الأسفل (Notch/Home indicator)
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  /// هل الشاشة في وضع العرض العرضي؟
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  // =========================================
  // 3️⃣ سحر التصميم والألوان (Theme) 🎨
  // =========================================

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // =========================================
  // 4️⃣ سحر لوحة المفاتيح (Keyboard) ⌨️
  // =========================================

  /// إخفاء الكيبورد بضغطة زر (مفيد جداً في شاشات البحث وتسجيل الدخول)
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // =========================================
  // 5️⃣ سحر الـ BLoC / Cubit (يتغير حسب كل مشروع) 🧠
  // =========================================

  // 💡 ملاحظة الـ Tech Lead:
  // هذا الجزء الوحيد الذي ستعدله في كل مشروع جديد لتضيف الكيوبتات الخاصة به.

  TaskCubit get taskCubit => read<TaskCubit>();
  LoginCubit get logincubit => read<LoginCubit>();
  RegisterCubit get registerCubit => read<RegisterCubit>();
  CreateTaskCubit get createTaskCubit => read<CreateTaskCubit>();
}
