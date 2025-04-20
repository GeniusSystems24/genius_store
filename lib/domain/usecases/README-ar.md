# حالات الاستخدام

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على فئات حالات الاستخدام التي تغلف منطق الأعمال لتطبيق Genius Store. تمثل كل حالة استخدام إجراءً أو معاملة محددة يمكن للمستخدم تنفيذها داخل النظام.

## الغرض

حالات الاستخدام:

- تغلف عملية أو إجراء أعمال واحد
- تنظم تدفق البيانات بين واجهة المستخدم وطبقة البيانات
- تطبق قواعد وتحقق الأعمال
- تتعامل مع أخطاء مستوى الأعمال
- توفر واجهة برمجة تطبيقات نظيفة لطبقة العرض لتنفيذ عمليات الأعمال

## المفهوم الرئيسي: المسؤولية الواحدة

تتبع كل حالة استخدام مبدأ المسؤولية الواحدة من خلال التركيز على عملية أعمال محددة واحدة. هذا النهج:

- يجعل قاعدة الشفرة أكثر قابلية للصيانة والاختبار
- يضمن أن منطق الأعمال مستقل عن اهتمامات واجهة المستخدم
- يسمح بإعادة استخدام منطق الأعمال بسهولة عبر مكونات واجهة المستخدم المختلفة
- يوفر توثيقًا واضحًا لما يمكن أن يفعله التطبيق

## الهيكل

تتبع فئة حالة الاستخدام النموذجية هذه الاتفاقيات:

- فئة بسيطة مع طريقة `call()` واحدة (مما يجعلها قابلة للاستدعاء)
- تعتمد على مستودع واحد أو أكثر
- تقبل معلمات خاصة بالعملية
- تعيد `Future<Either<Failure, T>>` حيث T هو نوع النتيجة
- تستخدم حقن التبعية للمستودعات

## نمط التنفيذ

يتبع التطبيق نمطًا متسقًا لجميع حالات الاستخدام:

```dart
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}

class GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<Either<Failure, Product>> call(String productId) async {
    // التحقق من صحة المدخلات
    if (productId.isEmpty) {
      return Left(ValidationFailure('معرف المنتج لا يمكن أن يكون فارغًا'));
    }
    
    return await repository.getProductById(productId);
  }
}

class AddToCartUseCase {
  final CartRepository cartRepository;
  final ProductRepository productRepository;

  AddToCartUseCase({
    required this.cartRepository,
    required this.productRepository,
  });

  Future<Either<Failure, Cart>> call(AddToCartParams params) async {
    // التحقق من صحة المعلمات
    if (params.quantity <= 0) {
      return Left(ValidationFailure('يجب أن تكون الكمية أكبر من الصفر'));
    }
    
    // التحقق من توفر المنتج
    final productResult = await productRepository.getProductById(params.productId);
    
    return await productResult.fold(
      (failure) => Left(failure),
      (product) async {
        // تطبيق قواعد الأعمال
        if (!product.isActive) {
          return Left(BusinessFailure('المنتج غير متاح'));
        }
        
        // العثور على المتغير المحدد
        final variant = product.variants?.firstWhere(
          (v) => v.id == params.variantId,
          orElse: () => throw NotFoundException('المتغير غير موجود'),
        );
        
        if (variant == null) {
          return Left(ValidationFailure('متغير المنتج غير صالح'));
        }
        
        if (variant.stockQuantity < params.quantity) {
          return Left(BusinessFailure('لا توجد عناصر كافية في المخزون'));
        }
        
        // الإضافة إلى السلة
        return await cartRepository.addItemToCart(
          params.cartId,
          CartItem(
            id: '', // سيتم إنشاؤها بواسطة المستودع
            cartId: params.cartId,
            productId: params.productId,
            variantId: params.variantId,
            quantity: params.quantity,
            price: variant.price,
          ),
        );
      },
    );
  }
}

// فئة المعلمات لحالات الاستخدام المعقدة
class AddToCartParams {
  final String cartId;
  final String productId;
  final String variantId;
  final int quantity;

  AddToCartParams({
    required this.cartId,
    required this.productId,
    required this.variantId,
    required this.quantity,
  });
}
```

## فئات حالات الاستخدام

ينظم التطبيق حالات الاستخدام في فئات:

- **المصادقة**: التسجيل، تسجيل الدخول، إعادة تعيين كلمة المرور
- **الملف الشخصي للمستخدم**: عرض/تحديث الملف الشخصي، إدارة العناوين/طرق الدفع
- **تصفح المنتجات**: قائمة/بحث المنتجات، عرض التفاصيل، التصفية حسب الفئة
- **سلة التسوق**: إنشاء السلال، إضافة/إزالة العناصر، عرض محتويات السلة
- **الدفع**: إنشاء الطلب، معالجة الدفع، تأكيد الطلب
- **الطلبات**: عرض سجل الطلبات، تتبع حالة الطلب
- **قائمة الرغبات**: الإضافة إلى قائمة الرغبات، الإزالة من قائمة الرغبات، عرض قائمة الرغبات

## حقن التبعية

يتم توفير حالات الاستخدام لطبقة العرض من خلال حقن التبعية باستخدام Riverpod:

```dart
// تعريف الموفر
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsUseCase(repository);
});

// استخدام الموفر في ودجة أو نموذج عرض
final productsUseCase = ref.watch(getProductsUseCaseProvider);
final products = await productsUseCase();
```

## الاختبار

يجب اختبار حالات الاستخدام بشكل شامل:

- اختبار تطبيق قواعد الأعمال
- التحقق من معالجة الأخطاء للمدخلات غير الصالحة
- محاكاة المستودعات لاختبار سيناريوهات مختلفة
- ضمان التنسيق المناسب لمستودعات متعددة

مثال:

```dart
void main() {
  late AddToCartUseCase useCase;
  late MockCartRepository mockCartRepository;
  late MockProductRepository mockProductRepository;
  
  setUp(() {
    mockCartRepository = MockCartRepository();
    mockProductRepository = MockProductRepository();
    
    useCase = AddToCartUseCase(
      cartRepository: mockCartRepository,
      productRepository: mockProductRepository,
    );
  });
  
  test('يجب إضافة العنصر إلى السلة عندما تتحقق جميع الشروط', () async {
    // تنفيذ الاختبار
  });
  
  test('يجب إرجاع خطأ عندما يكون المنتج غير متاح', () async {
    // تنفيذ الاختبار
  });
  
  // المزيد من الاختبارات...
}
```
