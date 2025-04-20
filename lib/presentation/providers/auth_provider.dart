import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/user/get_current_user.dart';
import '../../domain/usecases/user/sign_in_with_email_password.dart';
import '../../domain/usecases/user/create_user_with_email_password.dart';
import '../../domain/usecases/user/sign_out.dart';
import 'repositories_provider.dart';

/// مزود حالة المصادقة
final authStateProvider = StreamProvider<auth.User?>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  return firebaseAuth.authStateChanges();
});

/// مزود المصادقة
final authProvider = Provider<AuthProvider>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthProvider(
    getCurrentUser: GetCurrentUser(userRepository),
    signIn: SignInWithEmailPassword(userRepository),
    createUser: CreateUserWithEmailPassword(userRepository),
    signOut: SignOut(userRepository),
  );
});

/// فئة مزود المصادقة
class AuthProvider {
  final GetCurrentUser _getCurrentUser;
  final SignInWithEmailPassword _signIn;
  final CreateUserWithEmailPassword _createUser;
  final SignOut _signOut;

  AuthProvider({
    required GetCurrentUser getCurrentUser,
    required SignInWithEmailPassword signIn,
    required CreateUserWithEmailPassword createUser,
    required SignOut signOut,
  })  : _getCurrentUser = getCurrentUser,
        _signIn = signIn,
        _createUser = createUser,
        _signOut = signOut;

  Future<auth.User?> getCurrentUser() => _getCurrentUser();

  Future<auth.User> signInWithEmailPassword(String email, String password) {
    return _signIn(email, password);
  }

  Future<auth.User> createUserWithEmailPassword(String email, String password) {
    return _createUser(email, password);
  }

  Future<void> signOut() => _signOut();
}
