import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../repositories/user_repository.dart';

/// حالة استخدام لتسجيل الدخول بالبريد الإلكتروني وكلمة المرور
class SignInWithEmailPassword {
  final UserRepository _repository;

  SignInWithEmailPassword(this._repository);

  /// استدعاء حالة الاستخدام لتسجيل الدخول وإرجاع المستخدم
  Future<auth.User> call(String email, String password) {
    return _repository.signInWithEmailAndPassword(email, password);
  }
}
