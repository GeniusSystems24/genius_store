# وحدة التوجيه (Routing Module)

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على نظام التنقل والتوجيه لتطبيق متجر Genius.

## الغرض

توفر وحدة التوجيه مكانًا مركزيًا لتعريف وإدارة والتنقل بين الشاشات في التطبيق. وهي:

- تعرّف مسارات مسماة لجميع الشاشات
- تتعامل مع إنشاء المسارات وتمرير المعلمات
- تدير انتقالات ورسوم التنقل المتحركة
- تنفذ حراس المسارات للمصادقة والتفويض

## المكونات

### AppRouter

فئة `AppRouter` هي وحدة التحكم الرئيسية للتوجيه:

- `generateRoute`: ينشئ كائنات المسار بناءً على أسماء المسارات والوسيطات
- `onUnknownRoute`: يتعامل مع التنقل إلى المسارات غير المعرفة
- طرق مساعدة للتنقل للعمليات الشائعة

### ثوابت المسارات

يتم تعريف ثوابت أسماء المسارات في `AppConstants` (ضمن وحدة الثوابت):

- `homeRoute`: المسار إلى الشاشة الرئيسية
- `productDetailsRoute`: المسار إلى شاشة تفاصيل المنتج
- `cartRoute`: المسار إلى سلة التسوق
- `checkoutRoute`: المسار إلى تدفق الدفع
- `profileRoute`: المسار إلى ملف المستخدم الشخصي
- وغيرها.

### حراس المسارات

يتضمن نظام التوجيه آليات حماية:

- `AuthGuard`: يتحقق من مصادقة المستخدم قبل التنقل إلى المسارات المحمية
- `MaintenanceGuard`: يعيد التوجيه إلى شاشة الصيانة عندما تكون الميزات غير متوفرة

## الاستخدام

### تعريف المسارات

يتم تعريف المسارات مركزيًا في طريقة `AppRouter.generateRoute`:

```dart
static Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppConstants.homeRoute:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
      
    case AppConstants.productDetailsRoute:
      final productId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(productId: productId),
      );
      
    // مسارات أخرى...
      
    default:
      return MaterialPageRoute(
        builder: (_) => const NotFoundScreen(),
      );
  }
}
```

### التنقل الأساسي

التنقل إلى المسارات المسماة:

```dart
// الانتقال إلى شاشة
Navigator.pushNamed(
  context, 
  AppConstants.productDetailsRoute,
  arguments: 'product-123',
);

// الانتقال واستبدال الشاشة الحالية
Navigator.pushReplacementNamed(
  context,
  AppConstants.homeRoute,
);

// الانتقال ومسح السجل
Navigator.pushNamedAndRemoveUntil(
  context,
  AppConstants.homeRoute,
  (route) => false,
);
```

### استخدام طرق مساعدة التنقل

توفر `AppRouter` طرق ملائمة:

```dart
// الانتقال إلى تفاصيل المنتج
AppRouter.toProductDetails(context, productId: 'product-123');

// الانتقال إلى الدفع
AppRouter.toCheckout(context, cart: currentCart);

// العودة إلى الشاشة الرئيسية ومسح السجل
AppRouter.toHomeAndClear(context);
```

## الروابط العميقة (Deep Linking)

يدعم نظام التوجيه الروابط العميقة إلى شاشات محددة من مصادر خارجية:

- مخطط URI: `geniusstore://`
- ربط من عناوين URI للروابط العميقة إلى مسارات التطبيق
- التعامل مع المعلمات من الروابط العميقة

## انتقالات المسارات

يمكن تعريف انتقالات مخصصة بين المسارات:

- انتقالات الشرائح
- انتقالات التلاشي
- انتقالات متحركة مخصصة

مثال:

```dart
// إنشاء انتقال تلاشي
static Route<dynamic> _createFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
```
