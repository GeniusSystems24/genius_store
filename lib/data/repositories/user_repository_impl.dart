import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../domain/repositories/user_repository.dart';
import '../datasources/datasources.dart';
import '../models/models.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuthDataSource _authDataSource;
  final FirestoreUserDataSource _userDataSource;

  UserRepositoryImpl({
    required FirebaseAuthDataSource authDataSource,
    required FirestoreUserDataSource userDataSource,
  })  : _authDataSource = authDataSource,
        _userDataSource = userDataSource;

  @override
  Stream<auth.User?> get authStateChanges => _authDataSource.authStateChanges;

  @override
  Future<auth.User?> getCurrentUser() {
    return _authDataSource.getCurrentUser();
  }

  @override
  Future<auth.User> signInWithEmailAndPassword(String email, String password) {
    return _authDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<auth.User> createUserWithEmailAndPassword(String email, String password) async {
    // Create the user with Firebase Auth
    final user = await _authDataSource.createUserWithEmailAndPassword(email, password);

    // Create user profile in Firestore
    await _userDataSource.createUserProfile(UserModel(
      uid: user.uid,
      email: user.email!,
      name: user.displayName ?? email.split('@').first, // Use part of email as name if no display name
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    ));

    return user;
  }

  @override
  Future<void> signOut() {
    return _authDataSource.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _authDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<UserModel> getUserProfile(String uid) {
    return _userDataSource.getUserProfile(uid);
  }

  @override
  Future<void> updateUserProfile(UserModel user) {
    return _userDataSource.updateUserProfile(user);
  }

  @override
  Future<List<AddressModel>> getUserAddresses(String uid) {
    return _userDataSource.getUserAddresses(uid);
  }

  @override
  Future<AddressModel> addUserAddress(AddressModel address) {
    return _userDataSource.addUserAddress(address);
  }

  @override
  Future<void> updateUserAddress(AddressModel address) {
    return _userDataSource.updateUserAddress(address);
  }

  @override
  Future<void> deleteUserAddress(String addressId) {
    return _userDataSource.deleteUserAddress(addressId);
  }

  @override
  Future<List<PaymentMethodModel>> getUserPaymentMethods(String uid) {
    return _userDataSource.getUserPaymentMethods(uid);
  }

  @override
  Future<PaymentMethodModel> addUserPaymentMethod(PaymentMethodModel paymentMethod) {
    return _userDataSource.addUserPaymentMethod(paymentMethod);
  }

  @override
  Future<void> updateUserPaymentMethod(PaymentMethodModel paymentMethod) {
    return _userDataSource.updateUserPaymentMethod(paymentMethod);
  }

  @override
  Future<void> deleteUserPaymentMethod(String paymentMethodId) {
    return _userDataSource.deleteUserPaymentMethod(paymentMethodId);
  }
  
  @override
  Future<UserModel> getUserById(String uid) {
    return _userDataSource.getUserById(uid);
  }
  
  @override
  Future<void> updateUser(UserModel user) {
    return _userDataSource.updateUser(user);
  }
}
