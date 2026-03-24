import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart'; // نحتاجها لاستخدام debugPrint

class AppBlocObserver extends BlocObserver {
  // 🟢 1. تتنفذ عندما يتم إنشاء (فتح) أي Cubit جديد
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('🟢 Bloc Created: ${bloc.runtimeType}');
  }

  // 🔄 2. تتنفذ في كل مرة يتغير فيها الـ State في أي Cubit! (الأهم)
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // change تطبع لك الـ State القديم والـ State الجديد!
    debugPrint('🔄 Bloc Changed: ${bloc.runtimeType}, $change');
  }

  // ❌ 3. تتنفذ إذا حدث أي Error داخل الـ Cubit ولم تقم بمعالجته
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('❌ Bloc Error: ${bloc.runtimeType}, $error');
  }

  // 🔴 4. تتنفذ عندما يتم تدمير (إغلاق) الـ Cubit للحفاظ على الذاكرة
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('🔴 Bloc Closed: ${bloc.runtimeType}');
  }
}