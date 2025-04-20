# واجهات المستودعات

[![الإنجليزية](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على فئات مجردة تحدد عقود الوصول إلى البيانات لتطبيق متجر جينيوس. تحدد هذه الواجهات كيفية تفاعل طبقة المجال مع البيانات دون معرفة تفاصيل التنفيذ.

## الغرض

واجهات المستودعات:

- تحدد العقد بين طبقات المجال والبيانات
- تحدد عمليات البيانات دون تفاصيل التنفيذ
- تمكّن من مبدأ عكس التبعية (تعرّف طبقة المجال الواجهة، وتنفذها طبقة البيانات)
- تسهل الاختبار من خلال المحاكاة
- تؤسس فصلاً واضحاً للمسؤوليات

## المفهوم الرئيسي: عكس التبعية

واجهات المستودعات هي تطبيق رئيسي لمبدأ عكس التبعية (الحرف 'D' في SOLID):

- يجب ألا تعتمد الوحدات عالية المستوى (المجال) على الوحدات منخفضة المستوى (البيانات)
- يجب أن تعتمد كلاهما على التجريدات (الواجهات)
- يجب ألا تعتمد التجريدات على التفاصيل
- يجب أن تعتمد التفاصيل على التجريدات

من خلال تعريف واجهات المستودعات في طبقة المجال، تتحكم طبقة المجال في العقد وتبقى مستقلة عن تفاصيل تنفيذ البيانات.

## هيكل الواجهة

تتضمن واجهة المستودع النموذجية:

- طرق لعمليات CRUD على كيانات المجال
- طرق وصول أخرى للبيانات خاصة بمجال العمل
- استخدام نوع Either للعودة بنجاح أو فشل

مثال:

```dart
abstract class ProductRepository {
  /// الحصول على قائمة بجميع المنتجات
  Future<Either<Failure, List<Product>>> getProducts();
  
  /// الحصول على منتج بواسطة المعرّف الخاص به
  Future<Either<Failure, Product>> getProductById(String id);
  
  /// الحصول على منتجات حسب الفئة
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId);
  
  /// البحث عن منتجات بواسطة استعلام
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  
  /// الحصول على المنتجات المميزة
  Future<Either<Failure, List<Product>>> getFeaturedProducts();
  
  /// الحصول على متغيرات المنتج
  Future<Either<Failure, List<ProductVariant>>> getProductVariants(String productId);
}
```

## المستودعات المتاحة

يتضمن التطبيق واجهات المستودعات التالية:

- **AuthRepository**: عمليات المصادقة
- **UserRepository**: إدارة ملف تعريف المستخدم
- **ProductRepository**: الوصول إلى بيانات المنتج
- **CategoryRepository**: إدارة فئات المنتج
- **CartRepository**: عمليات سلة التسوق
- **OrderRepository**: معالجة الطلبات وتاريخها
- **PaymentRepository**: إدارة طرق الدفع
- **AddressRepository**: إدارة عناوين الشحن
- **WishlistRepository**: المنتجات المحفوظة/المفضلة

## معالجة الأخطاء

تستخدم واجهات المستودعات نوع Either (من حزمة dartz) لمعالجة الأخطاء:

- `Left<Failure>`: يمثل فشل العملية مع نوع فشل محدد
- `Right<T>`: يمثل عملية ناجحة مع النتيجة

هذا النهج:

- يجعل معالجة الأخطاء صريحة ومن المستحيل تجاهلها
- يسمح بأخطاء مكتوبة بدلاً من استثناءات عامة
- يفصل معالجة الأخطاء عن تدفق التحكم العادي

## متطلبات التنفيذ

يجب على تنفيذات هذه الواجهات في طبقة البيانات:

- إرجاع أنواع الكيانات المناسبة (وليس نماذج البيانات)
- التعامل مع جميع حالات الخطأ المحتملة
- ربط استثناءات مصدر البيانات بأخطاء المجال
- اتباع أي متطلبات للتخزين المؤقت أو الأولوية للوضع دون اتصال

## الاختبار

تستخدم طبقة المجال عادةً تنفيذات وهمية لهذه الواجهات لاختبار حالات الاستخدام:

```dart
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;
  
  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(mockRepository);
  });
  
  test('يجب الحصول على المنتجات من المستودع', () async {
    // الترتيب
    final products = [Product(...), Product(...)];
    when(mockRepository.getProducts())
        .thenAnswer((_) async => Right(products));
    
    // الفعل
    final result = await useCase();
    
    // التأكيد
    expect(result, Right(products));
    verify(mockRepository.getProducts());
    verifyNoMoreInteractions(mockRepository);
  });
}
