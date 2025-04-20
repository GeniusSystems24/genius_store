import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/address_model.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/address/get_user_addresses.dart';
import '../../domain/usecases/address/add_user_address.dart';
import '../../domain/usecases/address/update_user_address.dart';
import '../../domain/usecases/address/delete_user_address.dart';
import '../../domain/usecases/user/get_user_by_id.dart';
import '../../domain/usecases/user/update_user.dart';
import 'repositories_provider.dart';
import 'auth_provider.dart';

/// مزود بيانات المستخدم الحالي
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authProvider);
  final authUser = await authService.getCurrentUser();

  if (authUser == null) {
    return null;
  }

  final userProvider = ref.watch(userUseCasesProvider);
  return userProvider.getUserById(authUser.uid);
});

/// مزود حالات استخدام المستخدم
final userUseCasesProvider = Provider<UserUseCases>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserUseCases(
    getUserById: GetUserById(userRepository),
    updateUser: UpdateUser(userRepository),
    getUserAddresses: GetUserAddresses(userRepository),
    addUserAddress: AddUserAddress(userRepository),
    updateUserAddress: UpdateUserAddress(userRepository),
    deleteUserAddress: DeleteUserAddress(userRepository),
  );
});

/// فئة حالات استخدام المستخدم
class UserUseCases {
  final GetUserById _getUserById;
  final UpdateUser _updateUser;
  final GetUserAddresses _getUserAddresses;
  final AddUserAddress _addUserAddress;
  final UpdateUserAddress _updateUserAddress;
  final DeleteUserAddress _deleteUserAddress;

  UserUseCases({
    required GetUserById getUserById,
    required UpdateUser updateUser,
    required GetUserAddresses getUserAddresses,
    required AddUserAddress addUserAddress,
    required UpdateUserAddress updateUserAddress,
    required DeleteUserAddress deleteUserAddress,
  })  : _getUserById = getUserById,
        _updateUser = updateUser,
        _getUserAddresses = getUserAddresses,
        _addUserAddress = addUserAddress,
        _updateUserAddress = updateUserAddress,
        _deleteUserAddress = deleteUserAddress;

  Future<UserModel> getUserById(String uid) => _getUserById(uid);

  Future<void> updateUser(UserModel user) => _updateUser(user);

  Future<List<AddressModel>> getUserAddresses(String uid) => _getUserAddresses(uid);

  Future<void> addUserAddress(AddressModel address) => _addUserAddress(address);

  Future<void> updateUserAddress(AddressModel address) => _updateUserAddress(address);

  Future<void> deleteUserAddress(String addressId) => _deleteUserAddress(addressId);
}
