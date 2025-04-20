import '../../../data/models/user_model.dart';
import '../../repositories/user_repository.dart';

/// حالة استخدام لتحديث الملف الشخصي للمستخدم
class UpdateUserProfile {
  final UserRepository _repository;

  UpdateUserProfile(this._repository);

  /// استدعاء حالة الاستخدام لتحديث معلومات المستخدم
  Future<void> call(UserModel user) {
    return _repository.updateUserProfile(user);
  }
}
