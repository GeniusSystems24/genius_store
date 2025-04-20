import '../../repositories/user_repository.dart';
import '../../../data/models/user_model.dart';

class GetUserById {
  final UserRepository repository;

  GetUserById(this.repository);

  Future<UserModel> call(String uid) => repository.getUserById(uid);
}
