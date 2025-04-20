# وحدة معالجة الأخطاء

[![الإنجليزية](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على بنية معالجة الأخطاء لتطبيق متجر جينيوس.

## الغرض

توفر وحدة معالجة الأخطاء نهجًا منظمًا للتعامل مع الاستثناءات والأخطاء في جميع أنحاء التطبيق. حيث تقوم بـ:

- فصل الأخطاء حسب الطبقة (البيانات، المجال، العرض)
- توفير أنواع واضحة للأخطاء لسيناريوهات الفشل المختلفة
- تسهيل الإبلاغ عن الأخطاء والتعافي منها بشكل متسق
- تمكين الترجمة المناسبة للأخطاء إلى رسائل موجهة للمستخدم

## المكونات

### الاستثناءات

يحدد ملف `exceptions.dart` فئات الاستثناءات المخصصة لسيناريوهات الأخطاء المحددة:

- **ServerException**: يحدث عند وجود فشل في الاتصال بالخادم
- **CacheException**: يحدث عند وجود خطأ في عمليات تخزين البيانات المحلية
- **NetworkException**: يحدث عند عدم وجود اتصال بالإنترنت
- **AuthenticationException**: يحدث عند فشل المصادقة
- **ValidationException**: يحدث عند فشل التحقق من صحة البيانات

يتم إلقاء هذه الاستثناءات بشكل أساسي في طبقة البيانات.

### الأخطاء

يحدد ملف `failures.dart` فئات الأخطاء التي تمثل أخطاء منطق الأعمال:

- **Failure**: الفئة الأساسية المجردة لجميع الأخطاء
- **ServerFailure**: يشير إلى مشكلة متعلقة بالخادم
- **CacheFailure**: يشير إلى مشكلة في التخزين المحلي
- **NetworkFailure**: يشير إلى مشكلة في اتصال الشبكة
- **AuthenticationFailure**: يشير إلى مشاكل المصادقة
- **ValidationFailure**: يشير إلى أخطاء التحقق من صحة البيانات

يتم استخدام هذه الأخطاء في طبقات المجال والعرض.

### معالج الأخطاء

يوفر ملف `error_handler.dart` أدوات مساعدة لـ:

- تحويل الاستثناءات إلى أخطاء
- ربط الأخطاء برسائل ودية للمستخدم
- تسجيل الأخطاء بشكل مناسب
- التعامل مع الأخطاء العامة

## الاستخدام

### التعامل مع الاستثناءات

في مصادر البيانات أو المستودعات:

```dart
try {
  // استدعاء واجهة برمجة التطبيقات أو عملية قاعدة البيانات
} on ServerException catch (e) {
  return Left(ServerFailure(e.message));
} on CacheException catch (e) {
  return Left(CacheFailure(e.message));
} catch (e) {
  return Left(UnexpectedFailure(e.toString()));
}
```

### استخدام الأخطاء مع Either

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

### عرض رسائل ودية للمستخدم

في طبقة العرض:

```dart
state.productResult.fold(
  (failure) => Text(ErrorHandler.getErrorMessage(failure)),
  (products) => ProductListView(products: products),
);
```

## تقارير الأخطاء

يتم تسجيل الأخطاء الخطيرة تلقائيًا باستخدام خدمة التسجيل في التطبيق للتحليل وتصحيح الأخطاء لاحقًا.
