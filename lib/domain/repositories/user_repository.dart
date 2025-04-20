import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../data/models/models.dart';

abstract class UserRepository {
  Stream<auth.User?> get authStateChanges;

  Future<auth.User?> getCurrentUser();

  Future<auth.User> signInWithEmailAndPassword(String email, String password);

  Future<auth.User> createUserWithEmailAndPassword(String email, String password);

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<UserModel> getUserProfile(String uid);

  Future<void> updateUserProfile(UserModel user);

  Future<List<AddressModel>> getUserAddresses(String uid);

  Future<AddressModel> addUserAddress(AddressModel address);

  Future<void> updateUserAddress(AddressModel address);

  Future<void> deleteUserAddress(String addressId);

  Future<List<PaymentMethodModel>> getUserPaymentMethods(String uid);

  Future<PaymentMethodModel> addUserPaymentMethod(PaymentMethodModel paymentMethod);

  Future<void> updateUserPaymentMethod(PaymentMethodModel paymentMethod);

  Future<void> deleteUserPaymentMethod(String paymentMethodId);

  Future<UserModel> getUserById(String uid);

  Future<void> updateUser(UserModel user);
}
