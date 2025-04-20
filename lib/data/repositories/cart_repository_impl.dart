import '../../domain/repositories/cart_repository.dart';
import '../datasources/datasources.dart';
import '../models/models.dart';

class CartRepositoryImpl implements CartRepository {
  final FirestoreCartDataSource _cartDataSource;
  final FirestoreProductDataSource _productDataSource;

  CartRepositoryImpl({
    required FirestoreCartDataSource cartDataSource,
    required FirestoreProductDataSource productDataSource,
  })  : _cartDataSource = cartDataSource,
        _productDataSource = productDataSource;

  @override
  Future<List<CartModel>> getUserCarts(String userId) async {
    return _cartDataSource.getUserCarts(userId);
  }

  @override
  Future<CartModel> getCartById(String cartId) async {
    final cart = await _cartDataSource.getCartById(cartId);

    // Load product details for each cart item
    if (cart.items != null && cart.items!.isNotEmpty) {
      final updatedItems = <CartItemModel>[];

      for (final item in cart.items!) {
        try {
          // Get product and variant details
          final product = await _productDataSource.getProductById(item.productId);
          final variant = await _productDataSource.getProductVariantById(item.variantId);

          // Create updated cart item with product and variant details
          updatedItems.add(CartItemModel(
            id: item.id,
            cartId: item.cartId,
            productId: item.productId,
            variantId: item.variantId,
            quantity: item.quantity,
            price: item.price,
            product: product,
            variant: variant,
          ));
        } catch (e) {
          // If we can't load product details, keep the original item
          updatedItems.add(item);
        }
      }

      // Return cart with updated items
      return CartModel(
        id: cart.id,
        userId: cart.userId,
        name: cart.name,
        createdAt: cart.createdAt,
        updatedAt: cart.updatedAt,
        isActive: cart.isActive,
        items: updatedItems,
      );
    }

    return cart;
  }

  @override
  Future<CartModel> createCart(CartModel cart) async {
    return _cartDataSource.createCart(cart);
  }

  @override
  Future<void> updateCart(CartModel cart) async {
    await _cartDataSource.updateCart(cart);
  }

  @override
  Future<void> deleteCart(String cartId) async {
    await _cartDataSource.deleteCart(cartId);
  }

  @override
  Future<List<CartItemModel>> getCartItems(String cartId) async {
    return _cartDataSource.getCartItems(cartId);
  }

  @override
  Future<CartItemModel> addCartItem(CartItemModel item) async {
    // Validate product and variant existence before adding to cart
    await _productDataSource.getProductById(item.productId);
    await _productDataSource.getProductVariantById(item.variantId);

    return _cartDataSource.addCartItem(item);
  }

  @override
  Future<void> updateCartItem(CartItemModel item) async {
    await _cartDataSource.updateCartItem(item);
  }

  @override
  Future<void> removeCartItem(String cartId, String itemId) async {
    await _cartDataSource.removeCartItem(cartId, itemId);
  }

  @override
  Future<void> clearCart(String cartId) async {
    await _cartDataSource.clearCart(cartId);
  }
}
