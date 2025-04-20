import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/datasources/remote/firebase_auth_datasource.dart';
import '../../data/datasources/remote/firestore_user_datasource.dart';
import '../../data/datasources/remote/firestore_product_datasource.dart';
import '../../data/datasources/remote/firestore_cart_datasource.dart';
import '../../data/datasources/remote/firestore_order_datasource.dart';
import '../../data/datasources/local/preferences_datasource.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/order_repository.dart';

// Data Sources Providers
final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSourceImpl(firebaseAuth: FirebaseAuth.instance);
});

final firestoreUserDataSourceProvider = Provider<FirestoreUserDataSource>((ref) {
  return FirestoreUserDataSourceImpl(firestore: FirebaseFirestore.instance);
});

final firestoreProductDataSourceProvider = Provider<FirestoreProductDataSource>((ref) {
  return FirestoreProductDataSourceImpl(firestore: FirebaseFirestore.instance);
});

final firestoreCartDataSourceProvider = Provider<FirestoreCartDataSource>((ref) {
  return FirestoreCartDataSourceImpl(firestore: FirebaseFirestore.instance);
});

final firestoreOrderDataSourceProvider = Provider<FirestoreOrderDataSource>((ref) {
  return FirestoreOrderDataSourceImpl(firestore: FirebaseFirestore.instance);
});

final preferencesDataSourceProvider = Provider<PreferencesDataSource>((ref) {
  throw UnimplementedError('يجب تهيئة هذا المزود باستخدام FutureProvider أو في main');
});

// Repositories Providers
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final authDataSource = ref.watch(firebaseAuthDataSourceProvider);
  final userDataSource = ref.watch(firestoreUserDataSourceProvider);
  return UserRepositoryImpl(
    authDataSource: authDataSource,
    userDataSource: userDataSource,
  );
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final productDataSource = ref.watch(firestoreProductDataSourceProvider);
  return ProductRepositoryImpl(
    productDataSource: productDataSource,
  );
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final cartDataSource = ref.watch(firestoreCartDataSourceProvider);
  final productDataSource = ref.watch(firestoreProductDataSourceProvider);
  return CartRepositoryImpl(
    cartDataSource: cartDataSource,
    productDataSource: productDataSource,
  );
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final orderDataSource = ref.watch(firestoreOrderDataSourceProvider);
  final productDataSource = ref.watch(firestoreProductDataSourceProvider);
  return OrderRepositoryImpl(
    orderDataSource: orderDataSource,
    productDataSource: productDataSource,
  );
});
