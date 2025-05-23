# وحدة الثوابت

[![الإنجليزية](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على القيم الثابتة المستخدمة في جميع أنحاء تطبيق متجر جينيوس.

## الغرض

الثوابت تمركز القيم الثابتة المستخدمة عبر التطبيق، مما يوفر:

- اتساق في التسمية والقيم
- مصدر واحد للحقيقة للقيم المهمة في التطبيق
- منع "الأرقام السحرية" والسلاسل النصية المضمنة
- تحسين قابلية قراءة الكود وصيانته

## المكونات

### AppConstants

الفئة الرئيسية التي تحتوي على ثوابت التطبيق العامة:

- **أسماء المسارات**: ثوابت مسارات التنقل
- **نقاط نهاية واجهة برمجة التطبيقات**: ثوابت مسارات واجهة برمجة التطبيقات
- **ثوابت واجهة المستخدم**: قيم الحشو، الهامش، التباعد
- **ثوابت الرسوم المتحركة**: قيم المدة للرسوم المتحركة
- **أنماط التعبير النمطي**: أنماط التحقق الشائعة
- **مفاتيح التخزين**: المفاتيح المستخدمة للتخزين المحلي

### التعدادات

أنواع التعداد التي تحدد مجموعات ثابتة من القيم:

- **OrderStatus**: قيم حالة الطلبات (معلق، قيد المعالجة، تم الشحن، إلخ)
- **PaymentType**: أنواع طرق الدفع
- **UserRole**: أدوار المستخدم المختلفة في التطبيق
- **NetworkStatus**: قيم حالة الاتصال

### ثوابت السلاسل النصية

الثوابت النصية المنظمة حسب الميزة:

- **ErrorMessages**: رسائل الخطأ القياسية
- **ValidationMessages**: رسائل التحقق من صحة الإدخال
- **SuccessMessages**: رسائل تأكيد النجاح

## الاستخدام

استيراد ملف الثوابت واستخدام القيم مباشرة:

```dart
import 'package:genius_store/core/constants/app_constants.dart';

// الانتقال إلى الشاشة الرئيسية
Navigator.pushNamed(context, AppConstants.homeRoute);

// تطبيق الحشو القياسي
Container(
  padding: EdgeInsets.all(AppConstants.defaultPadding),
  child: Text('Hello'),
);

// استخدام نمط التحقق
final emailRegex = RegExp(AppConstants.emailPattern);
```

## إرشادات

عند إضافة ثوابت جديدة:

1. تجميع الثوابت ذات الصلة معًا
2. استخدام أسماء واضحة ووصفية
3. إضافة تعليقات توضح الغرض من الثوابت المعقدة
4. النظر في إنشاء ملفات منفصلة للثوابت الخاصة بميزات محددة
5. تجنب إضافة قيم قابلة للتغيير كثوابت
