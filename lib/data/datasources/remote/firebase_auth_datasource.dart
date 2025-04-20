import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class FirebaseAuthDataSource {
  Stream<auth.User?> get authStateChanges;

  Future<auth.User?> getCurrentUser();

  Future<auth.User> signInWithEmailAndPassword(String email, String password);

  Future<auth.User> createUserWithEmailAndPassword(String email, String password);

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSourceImpl({
    auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<auth.User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<auth.User> signInWithEmailAndPassword(String email, String password) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user!;
  }

  @override
  Future<auth.User> createUserWithEmailAndPassword(String email, String password) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user!;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
