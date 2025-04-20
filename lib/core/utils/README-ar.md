# وحدة الأدوات المساعدة

[![الإنجليزية](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على دوال وفئات للأغراض العامة مستخدمة في جميع أنحاء تطبيق متجر جينيوس.

## الغرض

توفر وحدة الأدوات المساعدة وظائف شائعة الاستخدام وأدوات:

- تقلل من تكرار الكود
- تبسط العمليات الشائعة
- توحد تنفيذ الأنماط المستخدمة بشكل متكرر
- تعزز قابلية قراءة الكود وصيانته

## المكونات

### المسجل

يوفر ملف `logger.dart` نظام تسجيل موحد:

- مستويات سجل مختلفة (تصحيح، معلومات، تحذير، خطأ)
- تنسيق سجل متسق
- تصفية السجل على أساس البيئة
- التكامل مع تقارير الأعطال

```dart
final logger = AppLogger();
logger.d('رسالة تصحيح');
logger.i('رسالة معلومات');
logger.w('رسالة تحذير');
logger.e('رسالة خطأ', exception, stackTrace);
```

### منسق التاريخ

يقدم ملف `date_formatter.dart` أدوات مساعدة لمعالجة التاريخ والوقت:

- تنسيق التواريخ إلى تمثيلات سلسلة مختلفة
- تحليل سلاسل التاريخ
- حساب الأوقات النسبية (مثل "منذ ساعتين")
- التعامل مع تحويلات المنطقة الزمنية

```dart
// تنسيق تاريخ
final formattedDate = DateFormatter.format(
  DateTime.now(),
  format: DateFormat.medium,
);

// حساب الوقت النسبي
final relativeTime = DateFormatter.getRelativeTime(pastDate);
```

### المتحققون

يحتوي ملف `validators.dart` على دوال للتحقق من صحة البيانات:

- التحقق من صحة البريد الإلكتروني
- فحص قوة كلمة المرور
- التحقق من صحة رقم الهاتف
- التحقق من صحة بطاقة الائتمان
- التحقق من الحقول المطلوبة

```dart
// التحقق من صحة بريد إلكتروني
final isValid = Validators.isValidEmail('user@example.com');

// التحقق من قوة كلمة المرور
final strength = Validators.getPasswordStrength('p@ssw0rd');
```

### أدوات السلاسل النصية

يوفر ملف `string_utils.dart` مساعدات لمعالجة السلاسل النصية:

- دوال كتابة الأحرف الكبيرة
- الاقتطاع مع علامات الحذف
- تمييز مصطلحات البحث
- أقنعة السلاسل النصية (مثلاً، لبطاقات الائتمان أو أرقام الهواتف)

```dart
// كتابة الحرف الأول بحرف كبير في سلسلة نصية
final capitalized = StringUtils.capitalize('hello');

// اقتطاع مع علامات الحذف
final truncated = StringUtils.truncate('نص طويل للاقتطاع', 10);
```

### أدوات الأرقام

يحتوي ملف `number_utils.dart` على دوال مساعدة للأرقام:

- تنسيق الأرقام
- تنسيق العملة
- تحويلات الوحدات
- مساعدات التقريب

```dart
// تنسيق كعملة
final price = NumberUtils.formatCurrency(19.99, 'USD');

// تنسيق بدقة
final formatted = NumberUtils.formatWithPrecision(3.14159, 2);
```

### أدوات الجهاز

يوفر ملف `device_utils.dart` أدوات مساعدة خاصة بالجهاز:

- اكتشاف حجم الشاشة
- اكتشاف المنصة
- فحص قدرات الجهاز
- حسابات المنطقة الآمنة

```dart
// التحقق مما إذا كان الجهاز iOS
final isIOS = DeviceUtils.isIOS();

// الحصول على نوع الجهاز
final deviceType = DeviceUtils.getDeviceType();
```

### أدوات واجهة المستخدم

يحتوي ملف `ui_utils.dart` على دوال مساعدة لواجهة المستخدم:

- عرض أشرطة الإشعارات
- عرض مربعات الحوار
- التعامل مع رؤية لوحة المفاتيح
- إدارة التركيز

```dart
// عرض شريط إشعارات
UIUtils.showSnackBar(context, 'تمت إضافة العنصر إلى السلة');

// عرض مربع حوار
await UIUtils.showConfirmationDialog(
  context,
  title: 'تأكيد',
  message: 'هل أنت متأكد؟',
);
```

### الامتدادات

ملفات امتداد مختلفة تضيف وظائف إلى الأنواع الحالية:

- `context_extensions.dart`: يضيف طرق مساعدة إلى BuildContext
- `string_extensions.dart`: يوسع وظائف فئة String
- `list_extensions.dart`: يعزز عمليات List
- `datetime_extensions.dart`: يضيف طرق إلى DateTime

```dart
// امتداد Context لحجم الشاشة
final screenWidth = context.screenWidth;

// امتداد String
final slugified = 'Hello World'.slugify();  // "hello-world"
```

## أفضل الممارسات

عند استخدام أو إنشاء أدوات مساعدة:

1. الحفاظ على تركيز دوال الأدوات المساعدة على مسؤولية واحدة
2. إضافة توثيق واضح لكل دالة
3. كتابة اختبارات وحدة لجميع دوال الأدوات المساعدة
4. تجنب الأدوات المساعدة ذات الحالة عندما يكون ذلك ممكنًا
5. تجميع الدوال ذات الصلة في وحدات منطقية
6. استخدام طرق الامتداد عند تحسين الأنواع الحالية
