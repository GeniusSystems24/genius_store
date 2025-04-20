import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../repositories/user_repository.dart';

/// حالة استخدام للحصول على المستخدم الحالي
class GetCurrentUser {
  final UserRepository repository;

  GetCurrentUser(this.repository);

  /// استدعاء حالة الاستخدام لإرجاع المستخدم الحالي المسجل الدخول
  Future<auth.User?> call() => repository.getCurrentUser();
}
