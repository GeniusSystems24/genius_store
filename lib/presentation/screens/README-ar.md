# الشاشات

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على جميع شاشات تطبيق Genius Store، منظمة حسب الميزة. تنفذ كل شاشة عرضًا متميزًا يتفاعل معه المستخدمون.

## الغرض

دليل الشاشات:

- ينظم شاشات واجهة المستخدم حسب الميزة/المجال
- ينفذ التخطيط المرئي لكل عرض تطبيق
- يتعامل مع تفاعلات المستخدم الخاصة بالشاشة
- يربط مكونات واجهة المستخدم بـ providers المناسبة
- يدير حالة ودورة حياة الشاشة

## هيكل الدليل

```text
screens/
├── auth/           # شاشات المصادقة (تسجيل الدخول، التسجيل، إعادة تعيين كلمة المرور)
├── cart/           # شاشات إدارة سلة التسوق
├── checkout/       # شاشات تدفق الدفع
├── home/           # الشاشة الرئيسية والعروض ذات الصلة
├── product/        # شاشات تصفح المنتجات والتفاصيل
└── profile/        # شاشات الملف الشخصي وإدارة الحساب
```

## نمط تنظيم الشاشة

تتبع كل شاشة نمط تنظيم متسق:

```mermaid
---
config:
  look: classic
  layout: elk
---
flowchart TD
    subgraph Feature Directory
        FeatureScreen["feature_screen.dart\n(الشاشة الرئيسية)"]
        Components["components/\n(مكونات خاصة بالشاشة)"]
    end
    
    FeatureScreen L_FeatureScreen_Components_0@--> |تحتوي على| Components
    CommonWidgets["../common_widgets/"] L_CommonWidgets_FeatureScreen_0@--> |توفر واجهة قابلة لإعادة الاستخدام لـ| FeatureScreen
    Providers["../providers/"] L_Providers_FeatureScreen_0@--> |تزود البيانات لـ| FeatureScreen
    
    linkStyle 0 stroke:#42A5F5,fill:none,stroke-width:2px
    linkStyle 1 stroke:#4CAF50,fill:none,stroke-width:2px
    linkStyle 2 stroke:#FFA000,fill:none,stroke-width:2px
    
    L_FeatureScreen_Components_0@{ animation: fast }
    L_CommonWidgets_FeatureScreen_0@{ animation: fast } 
    L_Providers_FeatureScreen_0@{ animation: fast }
```

### نمط تنفيذ الشاشة

تتبع كل شاشة عادةً هذا الهيكل:

1. **StatelessWidget أو ConsumerWidget** - ودجت الشاشة الرئيسية
2. **مكونات خاصة بالشاشة** - ودجات أصغر تستخدم فقط في هذه الشاشة
3. **استهلاك Provider** - استخدام Riverpod للوصول إلى حالة التطبيق
4. **منطق التنقل** - معالجة التنقل من/إلى هذه الشاشة

## مخططات تدفق الشاشة

### تدفق المصادقة

```mermaid
---
config:
  look: classic
  layout: elk
---
stateDiagram-v2
    [*] --> SplashScreen: يبدأ التطبيق
    SplashScreen --> LoginScreen: غير مصادق
    SplashScreen --> HomeScreen: مصادق بالفعل
    LoginScreen --> SignupScreen: ينقر على إنشاء حساب
    LoginScreen --> ForgotPasswordScreen: ينقر على نسيت كلمة المرور
    SignupScreen --> VerificationScreen: يكمل التسجيل
    ForgotPasswordScreen --> ResetPasswordScreen: يتحقق من الهوية
    VerificationScreen --> HomeScreen: يؤكد الحساب
    ResetPasswordScreen --> LoginScreen: يحدث كلمة المرور
    LoginScreen --> HomeScreen: يتم مصادقة المستخدم
    
    note right of SplashScreen: فحص حالة التطبيق الأولية
    note right of LoginScreen: نقطة دخول المصادقة
    note right of HomeScreen: تجربة التطبيق الرئيسية
    
    state SplashScreen {
        [*] --> CheckAuthState
        CheckAuthState --> Redirect
    }
    
    state LoginScreen {
        [*] --> ShowLoginForm
        ShowLoginForm --> ValidateCredentials: تقديم
        ValidateCredentials --> ShowError: غير صالح
        ValidateCredentials --> ProcessLogin: صالح
    }
```

### تدفق التسوق

```mermaid
---
config:
  look: classic
  layout: elk
---
stateDiagram-v2
    HomeScreen --> CategoryScreen: يتصفح الفئة
    HomeScreen --> SearchResultsScreen: يجري بحثًا
    HomeScreen --> ProductDetailsScreen: يختار منتجًا مميزًا
    CategoryScreen --> ProductDetailsScreen: ينقر على المنتج
    SearchResultsScreen --> ProductDetailsScreen: يختار نتيجة البحث
    ProductDetailsScreen --> CartScreen: يضيف إلى السلة
    CartScreen --> CheckoutScreen: يتابع إلى الدفع
    CheckoutScreen --> PaymentScreen: يؤكد الشحن
    PaymentScreen --> OrderConfirmationScreen: يكمل الدفع
    OrderConfirmationScreen --> HomeScreen: يعود للتسوق
    OrderConfirmationScreen --> OrderDetailsScreen: يعرض تفاصيل الطلب
    
    note right of HomeScreen: اكتشاف المنتج
    note right of ProductDetailsScreen: تقييم المنتج
    note right of CartScreen: تحضير الشراء
    note right of PaymentScreen: معالجة المعاملة
    
    state ProductDetailsScreen {
        [*] --> LoadProduct
        LoadProduct --> DisplayDetails
        DisplayDetails --> SelectVariants
        SelectVariants --> AddToCart
    }
    
    state CheckoutScreen {
        [*] --> ShowCart
        ShowCart --> SelectAddress
        SelectAddress --> SelectShipping
        SelectShipping --> ReviewOrder
    }
```

### تدفق إدارة الملف الشخصي

```mermaid
---
config:
  look: classic
  layout: elk
---
stateDiagram-v2
    HomeScreen --> ProfileScreen: يصل إلى الملف الشخصي
    ProfileScreen --> EditProfileScreen: يحدث المعلومات
    ProfileScreen --> AddressesScreen: يدير المواقع
    ProfileScreen --> PaymentMethodsScreen: يكوّن المدفوعات
    ProfileScreen --> OrderHistoryScreen: يتحقق من الطلبات السابقة
    ProfileScreen --> FavoritesScreen: يعرض العناصر المحفوظة
    OrderHistoryScreen --> OrderDetailsScreen: يفحص الطلب
    AddressesScreen --> AddEditAddressScreen: يعدل العنوان
    PaymentMethodsScreen --> AddEditPaymentScreen: يغير طريقة الدفع
    
    note right of ProfileScreen: مركز إدارة الحساب
    note right of OrderHistoryScreen: سجل المشتريات
    note right of AddressesScreen: مواقع التسليم
    
    state ProfileScreen {
        [*] --> LoadUserData
        LoadUserData --> DisplayOptions
    }
    
    state OrderHistoryScreen {
        [*] --> FetchOrders
        FetchOrders --> DisplayOrderList
        DisplayOrderList --> FilterOrders
    }
```

## وصف الشاشات الرئيسية

### الشاشة الرئيسية

نقطة الدخول الرئيسية التي تعرض المنتجات المميزة والفئات والعروض الترويجية.

**الميزات:**

- معرض المنتجات
- التنقل بين الفئات
- وظيفة البحث
- لافتات ترويجية
- المنتجات التي تمت مشاهدتها مؤخرًا

### شاشة تفاصيل المنتج

تعرض معلومات مفصلة حول منتج معين.

**الميزات:**

- معرض صور المنتج
- معلومات المنتج (الاسم، السعر، الوصف)
- اختيار اللون والحجم
- وظيفة الإضافة إلى السلة
- المراجعات والتقييمات
- المنتجات ذات الصلة

### شاشة سلة التسوق

تدير سلة تسوق المستخدم.

**الميزات:**

- قائمة بعناصر السلة
- تعديل الكمية
- إزالة العناصر
- تطبيق القسائم
- ملخص السلة مع الإجماليات
- المتابعة إلى الدفع

### شاشة الدفع

تتعامل مع عملية الدفع.

**الميزات:**

- اختيار عنوان الشحن
- اختيار طريقة التسليم
- اختيار طريقة الدفع
- ملخص الطلب
- تطبيق القسيمة
- وضع الطلب

## إرشادات تطوير الشاشة

عند إضافة أو تعديل الشاشات:

1. **التنظيم**: ضع الشاشات في دليل الميزة المناسب
2. **التكوين**: قم بتكوين الشاشات من مكونات أصغر ومركزة
3. **إدارة الحالة**: استخدم providers في Riverpod لإدارة الحالة
4. **التصميم المتجاوب**: تأكد من أن الشاشات تتكيف مع أحجام الأجهزة المختلفة
5. **معالجة الأخطاء**: قم بتنفيذ حالات وإشعارات الخطأ المناسبة
6. **حالات التحميل**: عرض مؤشرات التحميل للعمليات غير المتزامنة
7. **التنقل**: اتبع أنماط التنقل المعتمدة
8. **سهولة الوصول**: نفذ ميزات الوصول المناسبة

## أفضل الممارسات

- الحفاظ على تركيز ودجات الشاشة على التخطيط وتفاعل المستخدم
- استخراج مكونات واجهة المستخدم المعقدة إلى فئات ودجات منفصلة
- استخدام الودجات المشتركة للاتساق
- التعامل مع جميع حالات الشاشة: التحميل، النجاح، الخطأ، الفارغة
- تنفيذ سلوك التمرير المناسب لأحجام الشاشات المختلفة
- استخدام المسارات المسماة للتنقل بين الشاشات
- اتباع نظام تصميم التطبيق
