import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../repositories/user_repository.dart';

/// حالة استخدام لإنشاء مستخدم جديد بالبريد الإلكتروني وكلمة المرور
class CreateUserWithEmailPassword {
  final UserRepository _repository;

  CreateUserWithEmailPassword(this._repository);

  /// استدعاء حالة الاستخدام لإنشاء مستخدم جديد وإرجاعه
  Future<auth.User> call(String email, String password) {
    return _repository.createUserWithEmailAndPassword(email, password);
  }
}
