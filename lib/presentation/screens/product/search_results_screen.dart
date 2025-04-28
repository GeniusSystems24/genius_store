import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';
import 'components/search_filter_chip.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String query;

  const SearchResultsScreen({
    super.key,
    required this.query,
  });

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isGridView = true;
  final List<String> _activeFilters = [];

  // For demo purposes - in a real app these would come from a provider
  final List<Map<String, dynamic>> _availableFilters = [
    {'name': 'Electronics', 'type': 'category'},
    {'name': 'Clothing', 'type': 'category'},
    {'name': 'Home', 'type': 'category'},
    {'name': 'Under \$50', 'type': 'price'},
    {'name': '\$50-\$100', 'type': 'price'},
    {'name': 'Over \$100', 'type': 'price'},
    {'name': '4+ Stars', 'type': 'rating'},
    {'name': 'Free Shipping', 'type': 'shipping'},
    {'name': 'On Sale', 'type': 'sale'},
  ];

  // For demo purposes - in a real app these would come from a search provider
  late List<DummyProduct> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Create demo search results with query in the name
    _searchResults = List.generate(
      8,
      (index) => DummyProduct(
        id: 'search_$index',
        name: '${widget.query} Product ${index + 1}',
        price: (index * 15 + 25).toDouble(),
        imageUrl: 'assets/images/products/product_${(index % 4) + 1}.png',
        discount: index % 3 == 0 ? 10 : 0,
        rating: 3.0 + (index % 5) / 2,
        categories: ['Electronics', 'Featured'],
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_activeFilters.contains(filter)) {
        _activeFilters.remove(filter);
      } else {
        _activeFilters.add(filter);
      }
    });
  }

  List<DummyProduct> get _filteredResults {
    if (_activeFilters.isEmpty) {
      return _searchResults;
    }

    return _searchResults.where((product) {
      for (final filter in _activeFilters) {
        // This is a simplified filter logic for demo
        if (filter == 'On Sale' && product.discount == 0) {
          return false;
        }
        if (filter == '4+ Stars' && product.rating < 4.0) {
          return false;
        }
        if (filter == 'Under \$50' && product.price >= 50) {
          return false;
        }
        if (filter == '\$50-\$100' && (product.price < 50 || product.price > 100)) {
          return false;
        }
        if (filter == 'Over \$100' && product.price <= 100) {
          return false;
        }
        // Category filters
        if (filter == 'Electronics' && !product.categories.contains('Electronics')) {
          return false;
        }
        if (filter == 'Clothing' && !product.categories.contains('Clothing')) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ),
          onSubmitted: (value) {
            // Refresh search with new query
            setState(() {
              _performSearch();
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Active Filters
                if (_activeFilters.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      itemCount: _activeFilters.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SearchFilterChip(
                            label: _activeFilters[index],
                            onDeleted: () => _toggleFilter(_activeFilters[index]),
                          ),
                        );
                      },
                    ),
                  ),

                // Search Results Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '${_filteredResults.length} results for "${_searchController.text}"',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: 'Relevance',
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                        items: ['Relevance', 'Price: Low to High', 'Price: High to Low', 'Newest', 'Rating'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // Sort logic would go here
                        },
                      ),
                    ],
                  ),
                ),

                // No Results Message
                if (_filteredResults.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Text(
                              'Try adjusting your search or filter to find what you\'re looking for',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _activeFilters.clear();
                              });
                            },
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Search Results
                if (_filteredResults.isNotEmpty)
                  Expanded(
                    child: _isGridView ? _buildProductsGrid() : _buildProductsList(),
                  ),
              ],
            ),
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredResults.length,
      itemBuilder: (context, index) {
        final product = _filteredResults[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredResults.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final product = _filteredResults[index];
        return _buildProductListItem(product);
      },
    );
  }

  Widget _buildProductCard(DummyProduct product) {
    final discountedPrice = product.discount > 0 ? product.price * (1 - product.discount / 100) : product.price;

    return GestureDetector(
      onTap: () {
        // Navigate to product details
        AppRouter.go(context, '${AppConstants.productDetailsRoute}/${product.id}');
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (product.discount > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${product.discount.toInt()}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Price
                  Row(
                    children: [
                      if (product.discount > 0) ...[
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListItem(DummyProduct product) {
    final discountedPrice = product.discount > 0 ? product.price * (1 - product.discount / 100) : product.price;

    return InkWell(
      onTap: () {
        // Navigate to product details
        AppRouter.go(context, '${AppConstants.productDetailsRoute}/${product.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Product Image
            Stack(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (product.discount > 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        '${product.discount.toInt()}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 4),

                  // Categories
                  Wrap(
                    spacing: 4,
                    children: product.categories.map((category) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 4),

                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Price
                  Row(
                    children: [
                      if (product.discount > 0) ...[
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Add to Cart Button
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                // Add to cart functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to cart'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Results',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          this.setState(() {
                            _activeFilters.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),

                  const Divider(),

                  // Filter Categories
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Filters
                          _buildFilterSection(
                            'Categories',
                            _availableFilters.where((f) => f['type'] == 'category').map((f) => f['name'] as String).toList(),
                            setState,
                          ),

                          // Price Filters
                          _buildFilterSection(
                            'Price Range',
                            _availableFilters.where((f) => f['type'] == 'price').map((f) => f['name'] as String).toList(),
                            setState,
                          ),

                          // Rating Filters
                          _buildFilterSection(
                            'Rating',
                            _availableFilters.where((f) => f['type'] == 'rating').map((f) => f['name'] as String).toList(),
                            setState,
                          ),

                          // Other Filters
                          _buildFilterSection(
                            'Other',
                            _availableFilters
                                .where((f) => f['type'] == 'shipping' || f['type'] == 'sale')
                                .map((f) => f['name'] as String)
                                .toList(),
                            setState,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    StateSetter setModalState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = _activeFilters.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setModalState(() {
                  setState(() {
                    _toggleFilter(option);
                  });
                });
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Dummy model for preview
class DummyProduct {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double discount;
  final double rating;
  final List<String> categories;

  DummyProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.discount,
    required this.rating,
    this.categories = const ['Electronics'],
  });
}
