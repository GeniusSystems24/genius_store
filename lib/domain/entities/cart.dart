import 'package:equatable/equatable.dart';
import 'cart_item.dart';

/// كيان السلة في طبقة الأعمال المنطقية
class Cart extends Equatable {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final List<CartItem>? items;

  const Cart({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.items,
  });

  double get subtotal {
    if (items == null || items!.isEmpty) return 0;
    return items!.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get itemCount {
    if (items == null) return 0;
    return items!.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        createdAt,
        updatedAt,
        isActive,
        items,
      ];
}
