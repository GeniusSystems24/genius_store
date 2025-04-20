import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/models.dart';

abstract class FirestoreCartDataSource {
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

class FirestoreCartDataSourceImpl implements FirestoreCartDataSource {
  final FirebaseFirestore _firestore;

  FirestoreCartDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<CartModel>> getUserCarts(String userId) async {
    final querySnapshot =
        await _firestore.collection('carts').where('user_id', isEqualTo: userId).orderBy('created_at', descending: true).get();

    final carts = querySnapshot.docs
        .map((doc) => CartModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();

    // Load items for each cart
    for (var i = 0; i < carts.length; i++) {
      final items = await getCartItems(carts[i].id);
      carts[i] = _attachItemsToCart(carts[i], items);
    }

    return carts;
  }

  @override
  Future<CartModel> getCartById(String cartId) async {
    final doc = await _firestore.collection('carts').doc(cartId).get();

    if (!doc.exists) {
      throw Exception('Cart not found');
    }

    // Create the basic cart
    final cart = CartModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });

    // Get cart items
    final items = await getCartItems(cartId);

    // Return cart with items
    return _attachItemsToCart(cart, items);
  }

  CartModel _attachItemsToCart(CartModel cart, List<CartItemModel> items) {
    return CartModel(
      id: cart.id,
      userId: cart.userId,
      name: cart.name,
      createdAt: cart.createdAt,
      updatedAt: cart.updatedAt,
      isActive: cart.isActive,
      items: items,
    );
  }

  @override
  Future<CartModel> createCart(CartModel cart) async {
    // Generate a timestamp
    final now = DateTime.now();

    // Prepare cart data
    final cartData = {
      ...cart.toJson(),
      'created_at': Timestamp.fromDate(now),
      'updated_at': Timestamp.fromDate(now),
    };

    // Add cart to Firestore
    final docRef = await _firestore.collection('carts').add(cartData);

    // Return cart with ID and timestamps
    return CartModel.fromJson({
      'id': docRef.id,
      ...cartData,
    });
  }

  @override
  Future<void> updateCart(CartModel cart) async {
    // Update timestamps
    final updates = {
      ...cart.toJson(),
      'updated_at': Timestamp.fromDate(DateTime.now()),
    };

    await _firestore.collection('carts').doc(cart.id).update(updates);
  }

  @override
  Future<void> deleteCart(String cartId) async {
    // First delete all cart items
    await clearCart(cartId);

    // Then delete the cart
    await _firestore.collection('carts').doc(cartId).delete();
  }

  @override
  Future<List<CartItemModel>> getCartItems(String cartId) async {
    final querySnapshot = await _firestore.collection('cart_items').where('cart_id', isEqualTo: cartId).get();

    return querySnapshot.docs
        .map((doc) => CartItemModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<CartItemModel> addCartItem(CartItemModel item) async {
    // Check if item already exists in cart
    final existingItem = await _findExistingCartItem(item.cartId, item.productId, item.variantId);

    if (existingItem != null) {
      // Update existing item quantity instead of adding a new one
      final updatedItem = CartItemModel(
        id: existingItem.id,
        cartId: existingItem.cartId,
        productId: existingItem.productId,
        variantId: existingItem.variantId,
        quantity: existingItem.quantity + item.quantity,
        price: item.price, // Use the most recent price
      );

      await updateCartItem(updatedItem);
      return updatedItem;
    }

    // Add new item to cart
    final docRef = await _firestore.collection('cart_items').add(item.toJson());

    // Update cart's updated_at timestamp
    await _firestore.collection('carts').doc(item.cartId).update({
      'updated_at': Timestamp.fromDate(DateTime.now()),
    });

    return CartItemModel.fromJson({
      'id': docRef.id,
      ...item.toJson(),
    });
  }

  Future<CartItemModel?> _findExistingCartItem(String cartId, String productId, String variantId) async {
    final querySnapshot = await _firestore
        .collection('cart_items')
        .where('cart_id', isEqualTo: cartId)
        .where('product_id', isEqualTo: productId)
        .where('variant_id', isEqualTo: variantId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    return CartItemModel.fromJson({
      'id': querySnapshot.docs.first.id,
      ...querySnapshot.docs.first.data(),
    });
  }

  @override
  Future<void> updateCartItem(CartItemModel item) async {
    await _firestore.collection('cart_items').doc(item.id).update(item.toJson());

    // Update cart's updated_at timestamp
    await _firestore.collection('carts').doc(item.cartId).update({
      'updated_at': Timestamp.fromDate(DateTime.now()),
    });
  }

  @override
  Future<void> removeCartItem(String cartId, String itemId) async {
    await _firestore.collection('cart_items').doc(itemId).delete();

    // Update cart's updated_at timestamp
    await _firestore.collection('carts').doc(cartId).update({
      'updated_at': Timestamp.fromDate(DateTime.now()),
    });
  }

  @override
  Future<void> clearCart(String cartId) async {
    // Get all items in the cart
    final querySnapshot = await _firestore.collection('cart_items').where('cart_id', isEqualTo: cartId).get();

    // Use a batch to delete all items
    final batch = _firestore.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Commit the batch delete
    await batch.commit();

    // Update cart's updated_at timestamp
    await _firestore.collection('carts').doc(cartId).update({
      'updated_at': Timestamp.fromDate(DateTime.now()),
    });
  }
}
