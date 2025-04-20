import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_widgets/product_card.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 0;
  int _quantity = 1;

  final PageController _pageController = PageController();

  // بيانات تجريبية للعرض
  final List<String> _images = [
    'https://example.com/product1.jpg',
    'https://example.com/product2.jpg',
    'https://example.com/product3.jpg',
  ];

  final List<Color> _colors = [
    Colors.black,
    Colors.blue,
    Colors.red,
  ];

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // شريط التطبيق
            SliverAppBar(
              pinned: true,
              title: Text('تفاصيل المنتج', style: Theme.of(context).textTheme.headlineMedium),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // مشاركة المنتج
                  },
                ),
              ],
            ),

            // محتوى الصفحة
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // معرض الصور
                  _buildImageGallery(),

                  // معلومات المنتج
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // اسم المنتج والتقييم
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'اسم المنتج التجريبي',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '4.8',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(240)',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // السعر
                        Row(
                          children: [
                            Text(
                              '350 ر.س',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '500 ر.س',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '30% خصم',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // اختيار اللون
                        Text(
                          'اللون',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        _buildColorSelector(),

                        const SizedBox(height: 16),

                        // اختيار المقاس
                        Text(
                          'المقاس',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        _buildSizeSelector(),

                        const SizedBox(height: 16),

                        // الكمية
                        Text(
                          'الكمية',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        _buildQuantitySelector(),

                        const SizedBox(height: 24),

                        // الوصف
                        Text(
                          'الوصف',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'هذا النص هو مثال لوصف المنتج. يمكن أن يتضمن معلومات عن المواد والميزات والاستخدامات وغيرها من التفاصيل المهمة للعميل.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 24),

                        // منتجات مشابهة
                        Text(
                          'منتجات مشابهة',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 160,
                                margin: const EdgeInsets.only(right: 16),
                                child: ProductCard(
                                  title: 'منتج مشابه ${index + 1}',
                                  imageUrl: 'https://example.com/product${index + 1}.jpg',
                                  price: 250.0 + (index * 50),
                                  discountPercentage: index % 2 == 0 ? 10 : null,
                                  rating: 4.5,
                                  onTap: () {
                                    // التنقل لصفحة المنتج
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomActions(),
    );
  }

  // معرض صور المنتج
  Widget _buildImageGallery() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          // عارض الصور
          PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                _images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // مؤشرات الصور
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _images.asMap().entries.map((entry) {
                return Container(
                  width: _currentImageIndex == entry.key ? 24 : 12,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentImageIndex == entry.key ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),
          ),

          // زر المفضلة
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // إضافة للمفضلة
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // اختيار اللون
  Widget _buildColorSelector() {
    return Wrap(
      spacing: 16,
      children: _colors.asMap().entries.map((entry) {
        final index = entry.key;
        final color = entry.value;
        final isSelected = index == _selectedColorIndex;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColorIndex = index;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
          ),
        );
      }).toList(),
    );
  }

  // اختيار المقاس
  Widget _buildSizeSelector() {
    return Wrap(
      spacing: 12,
      children: _sizes.asMap().entries.map((entry) {
        final index = entry.key;
        final size = entry.value;
        final isSelected = index == _selectedSizeIndex;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedSizeIndex = index;
            });
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              ),
            ),
            child: Center(
              child: Text(
                size,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // اختيار الكمية
  Widget _buildQuantitySelector() {
    return Row(
      children: [
        _buildQuantityButton(
          icon: Icons.remove,
          onPressed: () {
            if (_quantity > 1) {
              setState(() {
                _quantity--;
              });
            }
          },
        ),
        Container(
          width: 50,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              _quantity.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        _buildQuantityButton(
          icon: Icons.add,
          onPressed: () {
            setState(() {
              _quantity++;
            });
          },
        ),
        const SizedBox(width: 16),
        Text(
          'متبقي 10 قطع',
          style: TextStyle(
            color: Colors.green[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.grey[100],
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  // شريط الإجراءات السفلي
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () {
                // إضافة للسلة
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('إضافة للسلة'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                // شراء الآن
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('شراء الآن'),
            ),
          ),
        ],
      ),
    );
  }
}
