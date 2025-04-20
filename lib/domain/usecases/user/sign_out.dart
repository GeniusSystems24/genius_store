import '../../repositories/user_repository.dart';

/// حالة استخدام لتسجيل الخروج
class SignOut {
  final UserRepository repository;

  SignOut(this.repository);

  /// استدعاء حالة الاستخدام لتسجيل الخروج
  Future<void> call() => repository.signOut();
}
