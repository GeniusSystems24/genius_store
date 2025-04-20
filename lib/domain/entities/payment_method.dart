import 'package:equatable/equatable.dart';

/// كيان طريقة الدفع في طبقة الأعمال المنطقية
class PaymentMethod extends Equatable {
  final String id;
  final String userId;
  final String type;
  final String? lastDigits;
  final String? cardholderName;
  final DateTime? expiryDate;
  final bool isDefault;

  const PaymentMethod({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        lastDigits,
        cardholderName,
        expiryDate,
        isDefault,
      ];
}
