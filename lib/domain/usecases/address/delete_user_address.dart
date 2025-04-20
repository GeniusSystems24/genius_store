import '../../repositories/user_repository.dart';

/// حالة استخدام لحذف عنوان المستخدم
class DeleteUserAddress {
  final UserRepository repository;

  DeleteUserAddress(this.repository);

  /// استدعاء حالة الاستخدام لحذف العنوان بمعرفه
  Future<void> call(String addressId) => repository.deleteUserAddress(addressId);
}
