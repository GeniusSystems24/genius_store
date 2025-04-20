import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // هنا يمكن استخدام مزود سلة التسوق لجلب البيانات
    // final cartState = ref.watch(cartProvider);

    // لأغراض العرض، سنستخدم بيانات تجريبية
    final List<CartItemModel> items = [
      CartItemModel(
        id: '1',
        productId: '1',
        name: 'قميص رجالي كاجوال',
        price: 150.0,
        quantity: 1,
        imageUrl: 'https://example.com/product1.jpg',
        color: 'أسود',
        size: 'M',
      ),
      CartItemModel(
        id: '2',
        productId: '2',
        name: 'بنطلون جينز أزرق',
        price: 200.0,
        quantity: 2,
        imageUrl: 'https://example.com/product2.jpg',
        color: 'أزرق',
        size: 'L',
      ),
      CartItemModel(
        id: '3',
        productId: '3',
        name: 'حذاء رياضي',
        price: 300.0,
        quantity: 1,
        imageUrl: 'https://example.com/product3.jpg',
        color: 'أبيض',
        size: '43',
      ),
    ];

    // حساب المجموع
    final double subtotal = items.fold(0, (sum, item) => sum + (item.price * item.quantity));
    const double shipping = 15.0;
    final double total = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق'),
        actions: [
          // زر إنشاء سلة جديدة
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              _showCreateCartDialog(context);
            },
          ),
        ],
      ),
      body: items.isEmpty ? _buildEmptyCart(context) : _buildCartContent(context, items, subtotal, shipping, total),
      bottomNavigationBar: items.isEmpty ? null : _buildCheckoutButton(context, total),
    );
  }

  // عرض السلة الفارغة
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'سلة التسوق فارغة',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'استكشف المتجر وأضف منتجات إلى سلتك',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // التنقل إلى الصفحة الرئيسية
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('تصفح المنتجات'),
          ),
        ],
      ),
    );
  }

  // عرض محتوى السلة
  Widget _buildCartContent(
    BuildContext context,
    List<CartItemModel> items,
    double subtotal,
    double shipping,
    double total,
  ) {
    return Column(
      children: [
        // عنوان السلة
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السلة الافتراضية',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              // زر تغيير السلة
              TextButton.icon(
                onPressed: () {
                  _showSelectCartDialog(context);
                },
                icon: const Icon(Icons.swap_horiz),
                label: const Text('تغيير السلة'),
              ),
            ],
          ),
        ),

        // قائمة المنتجات
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildCartItem(context, item);
            },
          ),
        ),

        // ملخص السلة
        _buildCartSummary(context, subtotal, shipping, total),
      ],
    );
  }

  // عنصر في السلة
  Widget _buildCartItem(BuildContext context, CartItemModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // تفاصيل المنتج
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.color} - ${item.size}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // السعر والكمية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.price.toStringAsFixed(0)} ر.س',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Row(
                        children: [
                          _buildQuantityButton(
                            icon: Icons.remove,
                            onPressed: () {
                              // تقليل الكمية
                            },
                          ),
                          Container(
                            width: 40,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Center(
                              child: Text(
                                item.quantity.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          _buildQuantityButton(
                            icon: Icons.add,
                            onPressed: () {
                              // زيادة الكمية
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // زر الحذف
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                // حذف المنتج من السلة
              },
            ),
          ],
        ),
      ),
    );
  }

  // زر تغيير الكمية
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.grey[100],
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  // ملخص السلة
  Widget _buildCartSummary(
    BuildContext context,
    double subtotal,
    double shipping,
    double total,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // كوبون الخصم
          TextField(
            decoration: InputDecoration(
              hintText: 'أدخل كود الخصم',
              suffixIcon: TextButton(
                onPressed: () {
                  // تطبيق الكوبون
                },
                child: const Text('تطبيق'),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // المجموع الفرعي
          _buildSummaryRow(
            label: 'المجموع الفرعي',
            value: '${subtotal.toStringAsFixed(0)} ر.س',
          ),
          const SizedBox(height: 8),

          // رسوم الشحن
          _buildSummaryRow(
            label: 'رسوم الشحن',
            value: '${shipping.toStringAsFixed(0)} ر.س',
          ),
          const Divider(height: 24),

          // المجموع الكلي
          _buildSummaryRow(
            label: 'المجموع الكلي',
            value: '${total.toStringAsFixed(0)} ر.س',
            isBold: true,
          ),
        ],
      ),
    );
  }

  // صف في ملخص السلة
  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 16,
          ),
        ),
      ],
    );
  }

  // زر إكمال الشراء
  Widget _buildCheckoutButton(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // الانتقال لشاشة إتمام الشراء
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'إتمام الشراء (${total.toStringAsFixed(0)} ر.س)',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // حوار إنشاء سلة جديدة
  void _showCreateCartDialog(BuildContext context) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء سلة جديدة'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'اسم السلة',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = textController.text.trim();
              if (name.isNotEmpty) {
                // إنشاء سلة جديدة
                Navigator.pop(context);
              }
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    ).then((_) {
      textController.dispose();
    });
  }

  // حوار اختيار سلة
  void _showSelectCartDialog(BuildContext context) {
    // قائمة السلال المتاحة
    final List<String> carts = [
      'السلة الافتراضية',
      'سلة المنتجات المفضلة',
      'سلة الهدايا',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر سلة'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: carts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(carts[index]),
                onTap: () {
                  // تحديد السلة
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }
}

// نموذج عنصر السلة
class CartItemModel {
  final String id;
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final String color;
  final String size;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.color,
    required this.size,
  });
}
