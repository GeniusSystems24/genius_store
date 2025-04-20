import '../../../data/models/user_model.dart';
import '../../repositories/user_repository.dart';

/// حالة استخدام للحصول على الملف الشخصي للمستخدم
class GetUserProfile {
  final UserRepository _repository;

  GetUserProfile(this._repository);

  /// استدعاء حالة الاستخدام لجلب معلومات المستخدم
  Future<UserModel> call(String uid) {
    return _repository.getUserProfile(uid);
  }
}
