import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';
import 'components/color_selector.dart';
import 'components/size_selector.dart';
import 'components/product_image_gallery.dart';
import 'components/quantity_selector.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  // For demo purposes only - in a real app this would come from a provider
  final _dummyProduct = const DummyProductDetails(
    id: '1',
    name: 'Premium Wireless Headphones',
    description: 'High-quality wireless headphones with noise cancellation, '
        'premium sound quality, and extended battery life. Enjoy your music '
        'without distractions.',
    price: 129.99,
    discount: 15,
    rating: 4.5,
    reviewCount: 127,
    inStock: true,
    images: [
      'assets/images/products/headphones_1.png',
      'assets/images/products/headphones_2.png',
      'assets/images/products/headphones_3.png',
    ],
    colors: [
      {'name': 'Black', 'code': '#000000'},
      {'name': 'White', 'code': '#FFFFFF'},
      {'name': 'Blue', 'code': '#0000FF'},
    ],
    sizes: ['S', 'M', 'L'],
  );

  int _selectedImageIndex = 0;
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final discountedPrice = _dummyProduct.discount > 0 ? _dummyProduct.price * (1 - _dummyProduct.discount / 100) : _dummyProduct.price;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: true,
              title: const Text('Product Details'),
              actions: [
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Share product
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    // Navigate to cart
                    AppRouter.go(context, AppConstants.cartRoute);
                  },
                ),
              ],
            ),

            // Product Images Gallery
            SliverToBoxAdapter(
              child: ProductImageGallery(
                images: _dummyProduct.images,
                selectedIndex: _selectedImageIndex,
                onImageSelected: (index) {
                  setState(() {
                    _selectedImageIndex = index;
                  });
                },
              ),
            ),

            // Product Information
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      _dummyProduct.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 8),

                    // Rating and Reviews
                    Row(
                      children: [
                        // Rating stars
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < _dummyProduct.rating.floor()
                                  ? Icons.star
                                  : index < _dummyProduct.rating
                                      ? Icons.star_half
                                      : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_dummyProduct.rating} (${_dummyProduct.reviewCount} reviews)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Price Information
                    Row(
                      children: [
                        if (_dummyProduct.discount > 0) ...[
                          Text(
                            '\$${_dummyProduct.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '\$${discountedPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        if (_dummyProduct.discount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_dummyProduct.discount.toInt()}% OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Stock Information
                    Text(
                      _dummyProduct.inStock ? 'In Stock' : 'Out of Stock',
                      style: TextStyle(
                        color: _dummyProduct.inStock ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(height: 32),

                    // Color Selection
                    Text(
                      'Color',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ColorSelector(
                      colors: _dummyProduct.colors.map((c) => c['code'] as String).toList(),
                      selectedIndex: _selectedColorIndex,
                      onColorSelected: (index) {
                        setState(() {
                          _selectedColorIndex = index;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Size Selection
                    Text(
                      'Size',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SizeSelector(
                      sizes: _dummyProduct.sizes,
                      selectedIndex: _selectedSizeIndex,
                      onSizeSelected: (index) {
                        setState(() {
                          _selectedSizeIndex = index;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Quantity Selector
                    Text(
                      'Quantity',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    QuantitySelector(
                      quantity: _quantity,
                      onQuantityChanged: (newQuantity) {
                        setState(() {
                          _quantity = newQuantity;
                        });
                      },
                    ),

                    const Divider(height: 32),

                    // Product Description
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _dummyProduct.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Total Price
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '\$${(discountedPrice * _quantity).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Add to Cart Button
            Expanded(
              child: ElevatedButton(
                onPressed: _dummyProduct.inStock
                    ? () {
                        final selectedColor = _dummyProduct.colors[_selectedColorIndex];
                        final selectedSize = _dummyProduct.sizes[_selectedSizeIndex];

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added $_quantity ${_dummyProduct.name} (${selectedColor['name']}, $selectedSize) to cart',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy model for preview only
class DummyProductDetails {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discount;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final List<String> images;
  final List<Map<String, String>> colors;
  final List<String> sizes;

  const DummyProductDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    required this.images,
    required this.colors,
    required this.sizes,
  });
}
