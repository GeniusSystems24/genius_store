import 'package:equatable/equatable.dart';

/// كيان المستخدم في طبقة الأعمال المنطقية
class User extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? profileImage;

  const User({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    required this.createdAt,
    required this.lastLogin,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        name,
        phone,
        createdAt,
        lastLogin,
        profileImage,
      ];
}
