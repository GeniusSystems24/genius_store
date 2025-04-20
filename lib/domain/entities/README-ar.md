# كيانات المجال

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على كيانات الأعمال الأساسية لتطبيق Genius Store. تمثل هذه الكيانات كائنات الأعمال الأساسية التي تغلف أهم قواعد الأعمال.

## الغرض

كيانات المجال:

- تحدد هياكل البيانات الأساسية لمجال الأعمال
- تغلف قواعد الأعمال ومنطق التحقق
- تمثل مفاهيم الأعمال في التطبيق
- تبقى مستقلة عن كيفية تخزين البيانات أو عرضها
- توفر لغة مشتركة بين المطورين وخبراء المجال

## الخصائص الرئيسية

تتميز الكيانات في طبقة المجال بعدة خصائص مهمة:

1. **الاستقلالية عن الإطار**: لا تعتمد على أي إطار عمل خارجي
2. **التركيز على الأعمال**: تمثل مفاهيم الأعمال، وليس هياكل البيانات
3. **منطق التحقق**: تتضمن التحقق من قواعد الأعمال
4. **عدم قابلية التغيير**: عادة ما تكون غير قابلة للتغيير لمنع تغييرات الحالة غير المتوقعة
5. **لا توجد تبعيات خارجية**: تعتمد فقط على كيانات المجال الأخرى والأنواع الأساسية في دارت

## الكيانات الأساسية

### المستخدم (User)

يمثل `User` عميلاً للمتجر:

```dart
class User {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? profileImage;

  User({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    required this.createdAt,
    required this.lastLogin,
    this.profileImage,
  });
  
  // طرق منطق الأعمال
  bool get isVerified => email.isNotEmpty;
  
  // منطق التحقق
  bool hasValidContactInfo() {
    return email.isNotEmpty || (phone != null && phone!.isNotEmpty);
  }
}
```

### المنتج (Product)

يمثل `Product` العناصر المتاحة للشراء:

```dart
class Product {
  final String id;
  final Map<String, String> nameLocalized;
  final Map<String, String> descriptionLocalized;
  final double basePrice;
  final String brand;
  final String categoryId;
  final bool isFeatured;
  final bool isActive;
  final DateTime createdAt;
  final List<String> tags;
  final double averageRating;
  final List<ProductVariant>? variants;
  final List<ProductImage>? images;

  Product({
    required this.id,
    required this.nameLocalized,
    required this.descriptionLocalized,
    required this.basePrice,
    required this.brand,
    required this.categoryId,
    required this.isFeatured,
    required this.isActive,
    required this.createdAt,
    required this.tags,
    required this.averageRating,
    this.variants,
    this.images,
  });

  // طرق الأعمال
  String getName(String languageCode) {
    return nameLocalized[languageCode] ?? nameLocalized['en'] ?? '';
  }

  String getDescription(String languageCode) {
    return descriptionLocalized[languageCode] 
        ?? descriptionLocalized['en'] 
        ?? '';
  }
  
  // قواعد الأعمال
  bool get isAvailable => isActive && hasAvailableVariants();
  
  bool hasAvailableVariants() {
    if (variants == null || variants!.isEmpty) return false;
    return variants!.any((variant) => variant.isInStock);
  }
  
  double get lowestPrice {
    if (variants == null || variants!.isEmpty) return basePrice;
    return variants!.map((v) => v.price).reduce((a, b) => a < b ? a : b);
  }
}
```

### سلة التسوق (Cart)

يمثل `Cart` مجموعة من العناصر المحددة للشراء:

```dart
class Cart {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.items,
  });

  // حسابات الأعمال
  double get subtotal {
    if (items.isEmpty) return 0;
    return items.fold(0, (sum, item) => sum + item.total);
  }
  
  // طرق الأعمال
  Cart addItem(CartItem item) {
    final existingItemIndex = items.indexWhere(
      (i) => i.productId == item.productId && i.variantId == item.variantId
    );
    
    if (existingItemIndex >= 0) {
      // تحديث الكمية إذا كان العنصر موجودًا بالفعل
      final updatedItems = List<CartItem>.from(items);
      final existingItem = items[existingItemIndex];
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity
      );
      
      return copyWith(items: updatedItems, updatedAt: DateTime.now());
    } else {
      // إضافة عنصر جديد
      return copyWith(
        items: [...items, item],
        updatedAt: DateTime.now(),
      );
    }
  }
  
  // إنشاء نسخة مع حقول محدثة
  Cart copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    List<CartItem>? items,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      items: items ?? this.items,
    );
  }
}
```

## كيانات أخرى

تتضمن طبقة المجال كيانات أخرى مثل:

- **الطلب (Order)**: يمثل عملية شراء مكتملة
- **العنوان (Address)**: يمثل عنوان الشحن أو الفواتير
- **الفئة (Category)**: يمثل تجميعات المنتجات
- **الدفع (Payment)**: يمثل معلومات الدفع

## الاختلافات عن نماذج البيانات

تختلف كيانات المجال عن نماذج البيانات بعدة طرق:

1. **التركيز**: تركز الكيانات على مفاهيم وقواعد الأعمال، بينما تركز النماذج على تمثيل البيانات
2. **التبعيات**: ليس للكيانات تبعيات خارجية، بينما قد تعتمد النماذج على خصائص مصدر البيانات
3. **التسلسل**: لا تتعامل الكيانات مع التسلسل، بينما تقوم النماذج بذلك
4. **التحقق**: تحتوي الكيانات على التحقق من الأعمال، بينما تحتوي النماذج على التحقق من التنسيق

## الاختبار

يجب اختبار كيانات المجال بشكل شامل:

- طرق منطق الأعمال
- قواعد التحقق
- طرق معالجة الحالة
- الحالات الحرجة

نظرًا لأن الكيانات تحتوي على قواعد أعمال مهمة، فإن اختباراتها تعمل كوثائق لمتطلبات الأعمال.
