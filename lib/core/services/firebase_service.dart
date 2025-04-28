import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../errors/exceptions.dart';

/// Service class to handle Firebase operations
class FirebaseService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Getters for Firebase instances
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseAnalytics get analytics => _analytics;
  FirebaseMessaging get messaging => _messaging;

  // Authentication methods
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message, code: e.code);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message, code: e.code);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  // Firestore methods
  Future<DocumentSnapshot> getDocument(String collection, String documentId) async {
    try {
      return await _firestore.collection(collection).doc(documentId).get();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<void> setDocument(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(documentId).set(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<void> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(documentId).update(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Stream<QuerySnapshot> collectionStream(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  // Storage methods
  Future<String> uploadFile(String path, String fileName, dynamic file) async {
    try {
      final ref = _storage.ref().child(path).child(fileName);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // Analytics methods
  Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      // We don't throw exceptions for analytics to avoid disrupting the app
      print('Analytics error: ${e.toString()}');
    }
  }

  // Messaging methods
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // Get the current authenticated user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
