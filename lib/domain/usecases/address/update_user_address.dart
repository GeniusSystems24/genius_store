import '../../repositories/user_repository.dart';
import '../../../data/models/models.dart';

/// حالة استخدام لتحديث عنوان المستخدم
class UpdateUserAddress {
  final UserRepository repository;

  UpdateUserAddress(this.repository);

  /// استدعاء حالة الاستخدام لتحديث العنوان
  Future<void> call(AddressModel address) => repository.updateUserAddress(address);
}
