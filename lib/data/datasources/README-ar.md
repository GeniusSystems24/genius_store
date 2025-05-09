# مصادر البيانات

[![الإنجليزية](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي دليل مصادر البيانات على فئات تتعامل مع الاتصال المباشر مع مزودي البيانات المختلفين في تطبيق متجر جينيوس.

## الغرض

مصادر البيانات:

- تغلف تفاصيل كيفية استرجاع البيانات أو تخزينها
- توفر واجهة برمجة تطبيقات نظيفة لوصول المستودعات إلى البيانات
- تتعامل مع خصوصيات مزودي البيانات المختلفين (Firebase، التخزين المحلي، إلخ)
- تنفذ عمليات البيانات منخفضة المستوى (إنشاء، قراءة، تحديث، حذف)

## أنواع مصادر البيانات

### مصادر البيانات عن بُعد

تتعامل مصادر البيانات عن بُعد مع الاتصال بالخدمات الخارجية:

- **Firebase Firestore**: يسترجع ويخزن بيانات المنتجات والمستخدمين والطلبات في Firestore
- **Firebase Storage**: يدير تحميل الصور واسترجاعها
- **Firebase Authentication**: يتعامل مع عمليات مصادقة المستخدم
- **Cloud Functions**: يستدعي الدوال السحابية للعمليات المعقدة

مثال:

```dart
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;
  
  ProductRemoteDataSourceImpl({required this.firestore});
  
  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await firestore.collection('products').get();
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('فشل في جلب المنتجات: ${e.toString()}');
    }
  }
  
  // تنفيذات الطرق الأخرى...
}
```

### مصادر البيانات المحلية

تتفاعل مصادر البيانات المحلية مع التخزين على الجهاز:

- **SharedPreferences**: يخزن قطع صغيرة من البيانات (تفضيلات المستخدم، الرموز المميزة)
- **Hive/SQLite**: يخزن مجموعات بيانات أكبر للوصول دون اتصال
- **Secure Storage**: يدير البيانات الحساسة مع التشفير

مثال:

```dart
abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<void> clearCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  ProductLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonString = json.encode(
      products.map((product) => product.toJson()).toList(),
    );
    await sharedPreferences.setString('CACHED_PRODUCTS', jsonString);
  }
  
  // تنفيذات الطرق الأخرى...
}
```

## أنماط التصميم

تطبق مصادر البيانات عدة أنماط تصميم:

1. **نمط المستودع**: مصادر البيانات هي جزء من نمط المستودع، وتعمل كمزودي بيانات فعليين للمستودعات.

2. **نمط المحول**: تكيف مصادر البيانات تنسيقات البيانات الخارجية إلى تنسيق نموذج التطبيق.

3. **نمط الواجهة**: توفر واجهة مبسطة للأنظمة الفرعية المعقدة (مثل Firebase).

4. **نمط Singleton**: يمكن تنفيذ بعض مصادر البيانات كـ singletons لضمان وصول متسق إلى الموارد.

## معالجة الأخطاء

تستخدم مصادر البيانات نهجًا متسقًا لمعالجة الأخطاء:

- تلتقط استثناءات محددة للمزود
- تترجم هذه الاستثناءات إلى استثناءات خاصة بالتطبيق
- تتضمن رسائل خطأ ذات معنى وبيانات وصفية

على سبيل المثال:

```dart
@override
Future<UserModel> getUserProfile(String userId) async {
  try {
    final userDoc = await firestore.collection('users').doc(userId).get();
    
    if (!userDoc.exists) {
      throw NotFoundException('المستخدم بالمعرّف $userId غير موجود');
    }
    
    return UserModel.fromJson(userDoc.data()!);
  } on FirebaseException catch (e) {
    throw ServerException('خطأ في Firebase: ${e.message}');
  } catch (e) {
    throw ServerException('فشل في الحصول على ملف تعريف المستخدم: ${e.toString()}');
  }
}
```

## الاختبار

يجب اختبار مصادر البيانات بشكل منعزل:

- استخدام نماذج وهمية للتبعيات الخارجية (Firebase، SharedPreferences)
- اختبار سيناريوهات النجاح والفشل
- التحقق من معالجة الاستثناءات بشكل صحيح
- لاختبار التكامل، استخدم محاكيات Firebase أو مثيلات اختبار
