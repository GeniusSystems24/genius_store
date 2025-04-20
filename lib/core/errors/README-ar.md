# وحدة معالجة الأخطاء (Error Handling Module)

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على بنية معالجة الأخطاء لتطبيق متجر Genius.

## الغرض

توفر وحدة معالجة الأخطاء نهجًا منظمًا للتعامل مع الاستثناءات والإخفاقات في جميع أنحاء التطبيق. وهي:

- تفصل الأخطاء حسب الطبقة (البيانات، المجال، العرض)
- توفر أنواع أخطاء واضحة لسيناريوهات الفشل المختلفة
- تسهل الإبلاغ عن الأخطاء والتعافي منها بشكل متسق
- تمكّن الترجمة المناسبة للأخطاء للرسائل الموجهة للمستخدم

## المكونات

### الاستثناءات (Exceptions)

يحدد ملف `exceptions.dart` فئات استثناءات مخصصة لسيناريوهات أخطاء محددة:

- **ServerException**: يحدث عندما يكون هناك فشل في الاتصال بالخادم
- **CacheException**: يحدث عندما يكون هناك خطأ في عمليات تخزين البيانات المحلية
- **NetworkException**: يحدث عندما لا يكون هناك اتصال بالإنترنت
- **AuthenticationException**: يحدث عندما تفشل المصادقة
- **ValidationException**: يحدث عندما يفشل التحقق من صحة البيانات

يتم إلقاء هذه الاستثناءات بشكل أساسي في طبقة البيانات.

### الإخفاقات (Failures)

يحدد ملف `failures.dart` فئات الإخفاق التي تمثل أخطاء منطق الأعمال:

- **Failure**: فئة أساسية مجردة لجميع الإخفاقات
- **ServerFailure**: يشير إلى مشكلة متعلقة بالخادم
- **CacheFailure**: يشير إلى مشكلة في التخزين المحلي
- **NetworkFailure**: يشير إلى مشكلة في اتصال الشبكة
- **AuthenticationFailure**: يشير إلى مشاكل المصادقة
- **ValidationFailure**: يشير إلى أخطاء التحقق من صحة البيانات

تستخدم هذه الإخفاقات في طبقتي المجال والعرض.

### معالج الأخطاء (Error Handler)

يوفر ملف `error_handler.dart` أدوات مساعدة لـ:

- تحويل الاستثناءات إلى إخفاقات
- ربط الإخفاقات برسائل سهلة الفهم للمستخدم
- تسجيل الأخطاء بشكل مناسب
- التعامل مع الأخطاء العامة

## الاستخدام

### التعامل مع الاستثناءات

في مصادر البيانات أو المستودعات:

```dart
try {
  // استدعاء API أو عملية قاعدة بيانات
} on ServerException catch (e) {
  return Left(ServerFailure(e.message));
} on CacheException catch (e) {
  return Left(CacheFailure(e.message));
} catch (e) {
  return Left(UnexpectedFailure(e.toString()));
}
```

### استخدام الإخفاقات مع Either

تستخدم طبقة المجال `Either` (من حزمة `dartz`) لتمثيل النجاح أو الفشل:

```dart
// واجهة المستودع
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}

// حالة الاستخدام
class GetProductsUseCase {
  final ProductRepository repository;
  
  GetProductsUseCase(this.repository);
  
  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
```

### عرض رسائل سهلة الفهم للمستخدم

في طبقة العرض:

```dart
state.productResult.fold(
  (failure) => Text(ErrorHandler.getErrorMessage(failure)),
  (products) => ProductListView(products: products),
);
```

## الإبلاغ عن الأخطاء

يتم تسجيل الأخطاء الخطيرة تلقائيًا باستخدام خدمة التسجيل الخاصة بالتطبيق لتحليلها وتصحيحها لاحقًا.
