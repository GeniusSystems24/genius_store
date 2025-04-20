import '../../repositories/user_repository.dart';
import '../../../data/models/models.dart';

/// حالة استخدام للحصول على قائمة عناوين المستخدم
class GetUserAddresses {
  final UserRepository repository;

  GetUserAddresses(this.repository);

  /// استدعاء حالة الاستخدام لجلب قائمة العناوين
  Future<List<AddressModel>> call(String uid) => repository.getUserAddresses(uid);
}
