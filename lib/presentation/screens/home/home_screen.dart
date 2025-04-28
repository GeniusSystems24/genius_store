import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';
import '../../common_widgets/carousel_slider.dart';
import '../../common_widgets/category_card.dart';
import '../../common_widgets/product_card.dart';
import '../../common_widgets/section_title.dart';
import '../../common_widgets/search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, these would come from providers
    final categories = _getDummyCategories();
    final featuredProducts = _getDummyFeaturedProducts();
    final popularProducts = _getDummyPopularProducts();
    final newProducts = _getDummyNewProducts();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with search
            SliverAppBar(
              floating: true,
              title: Text('Genius Store', style: Theme.of(context).textTheme.headlineMedium),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // Navigate to notifications screen
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    // Navigate to cart screen
                    AppRouter.go(context, AppConstants.cartRoute);
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: AppSearchBar(
                    onSearch: (query) {
                      // Handle search
                    },
                  ),
                ),
              ),
            ),

            // Featured Products Carousel
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: AppCarouselSlider(
                  items: featuredProducts.map((product) => product.id).toList(),
                  height: 180,
                ),
              ),
            ),

            // Categories Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SectionTitle(
                  title: 'Categories',
                  onSeeAllPressed: () {
                    // Navigate to categories screen
                  },
                ),
              ),
            ),

            // Categories Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];
                    return CategoryCard(
                      title: category.name,
                      imageUrl: category.imageUrl,
                      onTap: () {
                        // Navigate to category products
                      },
                    );
                  },
                  childCount: categories.length > 8 ? 8 : categories.length,
                ),
              ),
            ),

            // Popular Products Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SectionTitle(
                  title: 'Popular Products',
                  onSeeAllPressed: () {
                    // Navigate to popular products screen
                  },
                ),
              ),
            ),

            // Popular Products Horizontal List
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: popularProducts.length,
                  itemBuilder: (context, index) {
                    final product = popularProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: ProductCard(
                        title: product.name,
                        imageUrl: product.imageUrl,
                        price: product.price,
                        discountPercentage: product.discount,
                        rating: product.rating,
                        onTap: () {
                          // Navigate to product details
                          AppRouter.go(
                            context,
                            AppConstants.productDetailsRoute,
                            pathParameters: {'productId': product.id},
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // New Products Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SectionTitle(
                  title: 'New Arrivals',
                  onSeeAllPressed: () {
                    // Navigate to new products screen
                  },
                ),
              ),
            ),

            // New Products Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = newProducts[index];
                    return ProductCard(
                      title: product.name,
                      imageUrl: product.imageUrl,
                      price: product.price,
                      discountPercentage: product.discount,
                      rating: product.rating,
                      onTap: () {
                        // Navigate to product details
                        AppRouter.go(
                          context,
                          AppConstants.productDetailsRoute,
                          pathParameters: {'productId': product.id},
                        );
                      },
                    );
                  },
                  childCount: newProducts.length > 4 ? 4 : newProducts.length,
                ),
              ),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Home is selected
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0: // Home
              // Already on home
              break;
            case 1: // Categories
              // Navigate to categories
              break;
            case 2: // Cart
              AppRouter.go(context, AppConstants.cartRoute);
              break;
            case 3: // Profile
              AppRouter.go(context, AppConstants.profileRoute);
              break;
          }
        },
      ),
    );
  }

  // Dummy data for preview purposes
  List<DummyCategory> _getDummyCategories() {
    return [
      DummyCategory(id: '1', name: 'Electronics', imageUrl: 'assets/images/categories/electronics.png'),
      DummyCategory(id: '2', name: 'Fashion', imageUrl: 'assets/images/categories/fashion.png'),
      DummyCategory(id: '3', name: 'Home', imageUrl: 'assets/images/categories/home.png'),
      DummyCategory(id: '4', name: 'Beauty', imageUrl: 'assets/images/categories/beauty.png'),
      DummyCategory(id: '5', name: 'Toys', imageUrl: 'assets/images/categories/toys.png'),
      DummyCategory(id: '6', name: 'Sports', imageUrl: 'assets/images/categories/sports.png'),
      DummyCategory(id: '7', name: 'Grocery', imageUrl: 'assets/images/categories/grocery.png'),
      DummyCategory(id: '8', name: 'Books', imageUrl: 'assets/images/categories/books.png'),
    ];
  }

  List<DummyProduct> _getDummyFeaturedProducts() {
    return [
      DummyProduct(
        id: '1',
        name: 'Wireless Headphones',
        imageUrl: 'assets/images/products/headphones.png',
        price: 129.99,
        discount: 20,
        rating: 4.5,
      ),
      DummyProduct(
        id: '2',
        name: 'Smart Watch',
        imageUrl: 'assets/images/products/smartwatch.png',
        price: 199.99,
        discount: 15,
        rating: 4.7,
      ),
      DummyProduct(
        id: '3',
        name: 'Air Purifier',
        imageUrl: 'assets/images/products/airpurifier.png',
        price: 249.99,
        discount: 10,
        rating: 4.3,
      ),
    ];
  }

  List<DummyProduct> _getDummyPopularProducts() {
    return [
      DummyProduct(
        id: '4',
        name: 'Bluetooth Speaker',
        imageUrl: 'assets/images/products/speaker.png',
        price: 79.99,
        discount: 0,
        rating: 4.8,
      ),
      DummyProduct(
        id: '5',
        name: 'Gaming Controller',
        imageUrl: 'assets/images/products/controller.png',
        price: 59.99,
        discount: 5,
        rating: 4.6,
      ),
      DummyProduct(
        id: '6',
        name: 'Smartphone',
        imageUrl: 'assets/images/products/smartphone.png',
        price: 899.99,
        discount: 0,
        rating: 4.9,
      ),
      DummyProduct(
        id: '7',
        name: 'Laptop Pro',
        imageUrl: 'assets/images/products/laptop.png',
        price: 1299.99,
        discount: 10,
        rating: 4.7,
      ),
    ];
  }

  List<DummyProduct> _getDummyNewProducts() {
    return [
      DummyProduct(
        id: '8',
        name: 'Smart Glasses',
        imageUrl: 'assets/images/products/glasses.png',
        price: 199.99,
        discount: 0,
        rating: 4.2,
      ),
      DummyProduct(
        id: '9',
        name: 'Fitness Tracker',
        imageUrl: 'assets/images/products/tracker.png',
        price: 89.99,
        discount: 5,
        rating: 4.5,
      ),
      DummyProduct(
        id: '10',
        name: 'Wireless Earbuds',
        imageUrl: 'assets/images/products/earbuds.png',
        price: 149.99,
        discount: 15,
        rating: 4.6,
      ),
      DummyProduct(
        id: '11',
        name: 'Drone Camera',
        imageUrl: 'assets/images/products/drone.png',
        price: 399.99,
        discount: 0,
        rating: 4.4,
      ),
    ];
  }
}

// Dummy models for preview purposes only
class DummyCategory {
  final String id;
  final String name;
  final String imageUrl;

  DummyCategory({required this.id, required this.name, required this.imageUrl});
}

class DummyProduct {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double discount;
  final double rating;

  DummyProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.discount,
    required this.rating,
  });
}
