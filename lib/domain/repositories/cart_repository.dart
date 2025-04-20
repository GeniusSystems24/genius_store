import '../../data/models/models.dart';

abstract class CartRepository {
  Future<List<CartModel>> getUserCarts(String userId);

  Future<CartModel> getCartById(String cartId);

  Future<CartModel> createCart(CartModel cart);

  Future<void> updateCart(CartModel cart);

  Future<void> deleteCart(String cartId);

  Future<List<CartItemModel>> getCartItems(String cartId);

  Future<CartItemModel> addCartItem(CartItemModel item);

  Future<void> updateCartItem(CartItemModel item);

  Future<void> removeCartItem(String cartId, String itemId);

  Future<void> clearCart(String cartId);
}
