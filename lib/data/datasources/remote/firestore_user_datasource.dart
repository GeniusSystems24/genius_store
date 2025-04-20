import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/models.dart';

abstract class FirestoreUserDataSource {
  Future<UserModel> getUserProfile(String uid);

  Future<void> createUserProfile(UserModel user);

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

class FirestoreUserDataSourceImpl implements FirestoreUserDataSource {
  final FirebaseFirestore _firestore;

  FirestoreUserDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User profile not found');
    }

    return UserModel.fromJson({
      'uid': doc.id,
      ...doc.data()!,
    });
  }

  @override
  Future<void> createUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }

  @override
  Future<List<AddressModel>> getUserAddresses(String uid) async {
    final querySnapshot = await _firestore.collection('addresses').where('user_id', isEqualTo: uid).get();

    return querySnapshot.docs
        .map((doc) => AddressModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<AddressModel> addUserAddress(AddressModel address) async {
    // If this is the first address or marked as default, make sure it's the only default
    if (address.isDefault) {
      await _resetDefaultAddresses(address.userId);
    }

    final docRef = await _firestore.collection('addresses').add(address.toJson());

    return address = AddressModel.fromJson({
      'id': docRef.id,
      ...address.toJson(),
    });
  }

  @override
  Future<void> updateUserAddress(AddressModel address) async {
    // If this address is being set as default, reset other defaults
    if (address.isDefault) {
      await _resetDefaultAddresses(address.userId);
    }

    await _firestore.collection('addresses').doc(address.id).update(address.toJson());
  }

  @override
  Future<void> deleteUserAddress(String addressId) async {
    await _firestore.collection('addresses').doc(addressId).delete();
  }

  Future<void> _resetDefaultAddresses(String userId) async {
    final batch = _firestore.batch();
    final addresses =
        await _firestore.collection('addresses').where('user_id', isEqualTo: userId).where('is_default', isEqualTo: true).get();

    for (final doc in addresses.docs) {
      batch.update(doc.reference, {'is_default': false});
    }

    await batch.commit();
  }

  @override
  Future<List<PaymentMethodModel>> getUserPaymentMethods(String uid) async {
    final querySnapshot = await _firestore.collection('payment_methods').where('user_id', isEqualTo: uid).get();

    return querySnapshot.docs
        .map((doc) => PaymentMethodModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<PaymentMethodModel> addUserPaymentMethod(PaymentMethodModel paymentMethod) async {
    // If this is the first payment method or marked as default, make sure it's the only default
    if (paymentMethod.isDefault) {
      await _resetDefaultPaymentMethods(paymentMethod.userId);
    }

    final docRef = await _firestore.collection('payment_methods').add(paymentMethod.toJson());

    return paymentMethod = PaymentMethodModel.fromJson({
      'id': docRef.id,
      ...paymentMethod.toJson(),
    });
  }

  @override
  Future<void> updateUserPaymentMethod(PaymentMethodModel paymentMethod) async {
    // If this payment method is being set as default, reset other defaults
    if (paymentMethod.isDefault) {
      await _resetDefaultPaymentMethods(paymentMethod.userId);
    }

    await _firestore.collection('payment_methods').doc(paymentMethod.id).update(paymentMethod.toJson());
  }

  @override
  Future<void> deleteUserPaymentMethod(String paymentMethodId) async {
    await _firestore.collection('payment_methods').doc(paymentMethodId).delete();
  }

  Future<void> _resetDefaultPaymentMethods(String userId) async {
    final batch = _firestore.batch();
    final paymentMethods =
        await _firestore.collection('payment_methods').where('user_id', isEqualTo: userId).where('is_default', isEqualTo: true).get();

    for (final doc in paymentMethods.docs) {
      batch.update(doc.reference, {'is_default': false});
    }

    await batch.commit();
  }

  @override
  Future<UserModel> getUserById(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();

    if (!docSnapshot.exists) {
      throw Exception('المستخدم غير موجود');
    }

    return UserModel.fromJson({
      'uid': docSnapshot.id,
      ...docSnapshot.data() ?? {},
    });
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }
}
