import '../../repositories/user_repository.dart';
import '../../../data/models/models.dart';

/// حالة استخدام لإضافة عنوان جديد للمستخدم
class AddUserAddress {
  final UserRepository repository;

  AddUserAddress(this.repository);

  /// استدعاء حالة الاستخدام لإضافة عنوان جديد وإرجاعه
  Future<AddressModel> call(AddressModel address) => repository.addUserAddress(address);
}
