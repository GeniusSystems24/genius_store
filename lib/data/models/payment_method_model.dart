import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel {
  final String id;
  final String userId;
  final String type;
  final String? lastDigits;
  final String? cardholderName;
  final DateTime? expiryDate;
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.userId,
    required this.type,
    this.lastDigits,
    this.cardholderName,
    this.expiryDate,
    required this.isDefault,
  });

  String get displayName {
    if (type == 'card' && lastDigits != null) {
      return 'Card ending in $lastDigits';
    }
    return type;
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      lastDigits: json['last_digits'],
      cardholderName: json['cardholder_name'],
      expiryDate: json['expiry_date'] != null ? (json['expiry_date'] as Timestamp).toDate() : null,
      isDefault: json['is_default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'last_digits': lastDigits,
      'cardholder_name': cardholderName,
      'expiry_date': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'is_default': isDefault,
    };
  }
}
