# وحدة السمة (Theme Module)

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على بنية التصميم المرئي لتطبيق متجر Genius.

## الغرض

توفر وحدة السمة تصميمًا مرئيًا متسقًا عبر التطبيق من خلال:

- تحديد مخططات الألوان والطباعة وأنماط المكونات
- دعم السمات الفاتحة والداكنة
- توحيد رموز التصميم وقرارات التصميم
- توفير أدوات مساعدة لإدارة السمة

## المكونات

### AppTheme

ملف `app_theme.dart` هو فئة تكوين السمة الرئيسية:

- يحدد كائنات `ThemeData` الفاتحة والداكنة
- يكوّن سمات المكونات العالمية (الأزرار، المدخلات، البطاقات، إلخ)
- يوفر طرق ملائمة لمعالجة السمة

### لوحة الألوان (Color Palette)

يحدد ملف `color_palette.dart` مخطط ألوان التطبيق:

- الألوان الأساسية
- الألوان الثانوية
- ألوان التمييز
- الألوان الدلالية (النجاح، الخطأ، التحذير، المعلومات)
- الألوان المحايدة (للخلفيات، النصوص، الفواصل)
- التدرجات وتركيبات الألوان

### الطباعة (Typography)

يحدد ملف `typography.dart` أنماط النص:

- عائلات الخطوط
- أحجام النص
- أوزان الخط
- ارتفاعات السطر
- تباعد الحروف
- أنماط النص لأغراض مختلفة (العناوين، النص الرئيسي، التسميات التوضيحية، إلخ)

### امتدادات السمة (Theme Extensions)

امتدادات سمة مخصصة للمكونات الخاصة بالتطبيق:

- `card_theme_extension.dart`: تصميم موسع للبطاقات
- `button_theme_extension.dart`: متغيرات أزرار مخصصة
- امتدادات أخرى خاصة بالمكونات

## الاستخدام

### الوصول إلى بيانات السمة

في الأدوات، يمكن الوصول إلى السمة من خلال طريقة `Theme.of(context)`:

```dart
final theme = Theme.of(context);

// استخدام الألوان
Container(
  color: theme.colorScheme.background,
  child: Text(
    'Hello',
    style: TextStyle(color: theme.colorScheme.onBackground),
  ),
);

// استخدام سمات النص
Text(
  'Heading',
  style: theme.textTheme.headline5,
);
```

### استخدام امتدادات السمة المخصصة

لامتدادات السمة الخاصة بالتطبيق:

```dart
// الحصول على امتداد سمة الزر المخصص
final buttonTheme = Theme.of(context).extension<ButtonThemeExtension>();

// استخدام نمط الزر المخصص
ElevatedButton(
  style: buttonTheme?.primaryOutlined,
  onPressed: () {},
  child: Text('Custom Button'),
);
```

### تبديل السمة

التبديل بين السمات الفاتحة والداكنة:

```dart
// في أداة ذات حالة أو مزود
ThemeMode _themeMode = ThemeMode.system;

// تحديث وضع السمة
void setThemeMode(ThemeMode mode) {
  setState(() {
    _themeMode = mode;
  });
}

// في MaterialApp
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: _themeMode,
  // ...
);
```

## مواءمة نظام التصميم

تتوافق وحدة السمة مع نظام تصميم التطبيق، مما يضمن:

- استخدام متسق للألوان والمسافات والطباعة
- التنفيذ المناسب لرموز التصميم
- تمثيل دقيق لأنماط المكونات
- دعم تطور نظام التصميم

## توسيع السمة

لإضافة عناصر سمة جديدة:

1. حدد الأنماط أو المكونات الجديدة في ملف السمة المناسب
2. للمكونات المعقدة، قم بإنشاء فئة امتداد جديدة
3. سجل الامتدادات مع السمة في `AppTheme`
4. وثّق أمثلة الاستخدام للمطورين الآخرين
