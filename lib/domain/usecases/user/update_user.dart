import '../../repositories/user_repository.dart';
import '../../../data/models/user_model.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<void> call(UserModel user) => repository.updateUser(user);
}
