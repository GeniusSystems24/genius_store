import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/payment_method_model.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  AddressModel? _selectedAddress;
  PaymentMethodModel? _selectedPaymentMethod;
  String _shippingMethod = 'standard'; // standard, express

  // بيانات تجريبية للعرض
  final List<AddressModel> _addresses = [
    AddressModel(
      id: '1',
      userId: 'user1',
      name: 'المنزل',
      street: 'شارع الملك فهد',
      city: 'الرياض',
      state: 'الرياض',
      country: 'المملكة العربية السعودية',
      postalCode: '12345',
      phone: '0512345678',
      isDefault: true,
    ),
    AddressModel(
      id: '2',
      userId: 'user1',
      name: 'العمل',
      street: 'شارع التحلية',
      city: 'جدة',
      state: 'مكة المكرمة',
      country: 'المملكة العربية السعودية',
      postalCode: '54321',
      phone: '0598765432',
      isDefault: false,
    ),
  ];

  final List<PaymentMethodModel> _paymentMethods = [
    PaymentMethodModel(
      id: '1',
      userId: 'user1',
      type: 'card',
      lastDigits: '4242',
      cardholderName: 'محمد أحمد',
      expiryDate: DateTime(2025, 12),
      isDefault: true,
    ),
    PaymentMethodModel(
      id: '2',
      userId: 'user1',
      type: 'mada',
      lastDigits: '1234',
      cardholderName: 'محمد أحمد',
      expiryDate: DateTime(2024, 6),
      isDefault: false,
    ),
  ];

  // معلومات الطلب
  final double _subtotal = 650.0;
  final double _standardShipping = 15.0;
  final double _expressShipping = 30.0;
  double _discount = 0.0;

  @override
  void initState() {
    super.initState();
    // تحديد العنوان وطريقة الدفع الافتراضية
    _selectedAddress = _addresses.firstWhere(
      (address) => address.isDefault,
      orElse: () => _addresses.first,
    );

    _selectedPaymentMethod = _paymentMethods.firstWhere(
      (method) => method.isDefault,
      orElse: () => _paymentMethods.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    // حساب التكلفة الإجمالية
    final shippingCost = _shippingMethod == 'standard' ? _standardShipping : _expressShipping;
    final total = _subtotal + shippingCost - _discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الشراء'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            _placeOrder();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      _currentStep == 2 ? 'تأكيد الطلب' : 'التالي',
                    ),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('رجوع'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // الخطوة 1: اختيار عنوان الشحن
          Step(
            title: const Text('عنوان الشحن'),
            content: _buildShippingAddressStep(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),

          // الخطوة 2: طريقة الشحن
          Step(
            title: const Text('طريقة الشحن'),
            content: _buildShippingMethodStep(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),

          // الخطوة 3: طريقة الدفع
          Step(
            title: const Text('طريقة الدفع'),
            content: _buildPaymentMethodStep(),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
      bottomSheet: _buildOrderSummary(total, shippingCost),
    );
  }

  // خطوة اختيار عنوان الشحن
  Widget _buildShippingAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عناوين الشحن
        ...List.generate(_addresses.length, (index) {
          final address = _addresses[index];
          final isSelected = _selectedAddress?.id == address.id;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedAddress = address;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: address.id,
                      groupValue: _selectedAddress?.id,
                      onChanged: (value) {
                        setState(() {
                          _selectedAddress = address;
                        });
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                address.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (address.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'افتراضي',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(address.street),
                          Text('${address.city}, ${address.state}, ${address.country}'),
                          Text('${address.postalCode} | ${address.phone}'),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        // تعديل العنوان
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        // إضافة عنوان جديد
        OutlinedButton.icon(
          onPressed: () {
            // إضافة عنوان جديد
          },
          icon: const Icon(Icons.add),
          label: const Text('إضافة عنوان جديد'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }

  // خطوة اختيار طريقة الشحن
  Widget _buildShippingMethodStep() {
    return Column(
      children: [
        // الشحن القياسي
        _buildShippingOption(
          title: 'الشحن القياسي',
          subtitle: 'توصيل خلال 3-5 أيام عمل',
          price: _standardShipping,
          value: 'standard',
          groupValue: _shippingMethod,
          onChanged: (value) {
            setState(() {
              _shippingMethod = value.toString();
            });
          },
        ),

        const SizedBox(height: 16),

        // الشحن السريع
        _buildShippingOption(
          title: 'الشحن السريع',
          subtitle: 'توصيل خلال 1-2 يوم عمل',
          price: _expressShipping,
          value: 'express',
          groupValue: _shippingMethod,
          onChanged: (value) {
            setState(() {
              _shippingMethod = value.toString();
            });
          },
        ),
      ],
    );
  }

  // خيار طريقة الشحن
  Widget _buildShippingOption({
    required String title,
    required String subtitle,
    required double price,
    required String value,
    required String groupValue,
    required Function(dynamic) onChanged,
  }) {
    final isSelected = value == groupValue;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              '${price.toStringAsFixed(0)} ر.س',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // خطوة اختيار طريقة الدفع
  Widget _buildPaymentMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // طرق الدفع المتاحة
        ...List.generate(_paymentMethods.length, (index) {
          final paymentMethod = _paymentMethods[index];
          final isSelected = _selectedPaymentMethod?.id == paymentMethod.id;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedPaymentMethod = paymentMethod;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Radio<String>(
                      value: paymentMethod.id,
                      groupValue: _selectedPaymentMethod?.id,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = paymentMethod;
                        });
                      },
                    ),
                    Icon(
                      paymentMethod.type == 'card' ? Icons.credit_card : Icons.account_balance_wallet,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                paymentMethod.type == 'card' ? 'بطاقة ائتمان' : 'مدى',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (paymentMethod.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'افتراضي',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            'تنتهي في •••• ${paymentMethod.lastDigits}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        // حذف طريقة الدفع
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        // إضافة طريقة دفع جديدة
        OutlinedButton.icon(
          onPressed: () {
            // إضافة طريقة دفع جديدة
          },
          icon: const Icon(Icons.add),
          label: const Text('إضافة طريقة دفع جديدة'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),

        const SizedBox(height: 16),

        // قسم كوبون الخصم
        TextField(
          decoration: InputDecoration(
            hintText: 'أدخل كود الخصم',
            suffixIcon: TextButton(
              onPressed: () {
                // تطبيق الكوبون
                setState(() {
                  _discount = 50.0; // قيمة تجريبية
                });
              },
              child: const Text('تطبيق'),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  // ملخص الطلب
  Widget _buildOrderSummary(double total, double shippingCost) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // تفاصيل التكلفة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المجموع الفرعي:'),
              Text('${_subtotal.toStringAsFixed(0)} ر.س'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الشحن:'),
              Text('${shippingCost.toStringAsFixed(0)} ر.س'),
            ],
          ),
          if (_discount > 0) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الخصم:'),
                Text(
                  '- ${_discount.toStringAsFixed(0)} ر.س',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ],
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجموع الكلي:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${total.toStringAsFixed(0)} ر.س',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // تنفيذ الطلب
  void _placeOrder() {
    // التحقق من البيانات المطلوبة
    if (_selectedAddress == null) {
      _showErrorSnackBar('يرجى اختيار عنوان للشحن');
      return;
    }

    if (_selectedPaymentMethod == null) {
      _showErrorSnackBar('يرجى اختيار طريقة دفع');
      return;
    }

    // إظهار حوار تأكيد الطلب
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الطلب'),
        content: const Text('هل أنت متأكد من رغبتك في إتمام الطلب؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // إنشاء الطلب
              Navigator.pop(context);
              _showOrderConfirmation();
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  // إظهار رسالة خطأ
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // إظهار شاشة تأكيد الطلب
  void _showOrderConfirmation() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderConfirmationScreen(),
      ),
    );
  }
}

// شاشة تأكيد الطلب
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 24),
            Text(
              'تم تأكيد طلبك بنجاح!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'رقم الطلب: #123456',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'سيتم إرسال تفاصيل الطلب إلى بريدك الإلكتروني',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // العودة للصفحة الرئيسية
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('متابعة التسوق'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // الانتقال لصفحة الطلبات
              },
              child: const Text('عرض الطلبات'),
            ),
          ],
        ),
      ),
    );
  }
}
