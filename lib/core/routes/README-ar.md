# وحدة التوجيه

[![الإنجليزية](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على نظام التنقل والتوجيه لتطبيق متجر جينيوس.

## الغرض

توفر وحدة التوجيه مكانًا مركزيًا لتعريف وإدارة والتنقل بين الشاشات في التطبيق. فهي:

- تعرّف مسارات مسماة لجميع الشاشات
- تتعامل مع إنشاء المسارات وتمرير المعلمات
- تدير انتقالات التنقل والرسوم المتحركة
- تنفذ حراس المسار للمصادقة والتفويض

## المكونات

### AppRouter

فئة `AppRouter` هي المتحكم الرئيسي للتوجيه:

- `generateRoute`: ينشئ كائنات المسار استنادًا إلى أسماء المسارات والوسيطات
- `onUnknownRoute`: يتعامل مع التنقل إلى المسارات غير المعرفة
- طرق مساعدة للتنقل للعمليات الشائعة

### ثوابت المسار

يتم تعريف ثوابت اسم المسار في `AppConstants` (ضمن وحدة الثوابت):

- `homeRoute`: المسار إلى الشاشة الرئيسية
- `productDetailsRoute`: المسار إلى شاشة تفاصيل المنتج
- `cartRoute`: المسار إلى سلة التسوق
- `checkoutRoute`: المسار إلى تدفق الدفع
- `profileRoute`: المسار إلى ملف المستخدم الشخصي
- الخ.

### حراس المسار

يتضمن نظام التوجيه آليات حماية:

- `AuthGuard`: يتحقق من مصادقة المستخدم قبل الانتقال إلى المسارات المحمية
- `MaintenanceGuard`: يعيد التوجيه إلى شاشة الصيانة عندما تكون الميزات غير متوفرة

## الاستخدام

### إعلان المسارات

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

// الانتقال ومسح التاريخ
Navigator.pushNamedAndRemoveUntil(
  context,
  AppConstants.homeRoute,
  (route) => false,
);
```

### استخدام طرق التنقل المساعدة

يوفر `AppRouter` طرقًا ملائمة:

```dart
// الانتقال إلى تفاصيل المنتج
AppRouter.toProductDetails(context, productId: 'product-123');

// الانتقال إلى الدفع
AppRouter.toCheckout(context, cart: currentCart);

// العودة إلى الشاشة الرئيسية ومسح التاريخ
AppRouter.toHomeAndClear(context);
```

## الروابط العميقة

يدعم نظام التوجيه الروابط العميقة إلى شاشات محددة من مصادر خارجية:

- مخطط URI: `geniusstore://`
- ربط من عناوين URI للروابط العميقة إلى مسارات التطبيق
- التعامل مع المعلمات من الروابط العميقة

## انتقالات المسار

يمكن تعريف انتقالات مخصصة بين المسارات:

- انتقالات الشرائح
- انتقالات التلاشي
- انتقالات رسوم متحركة مخصصة

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
