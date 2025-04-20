# النواة (Core)

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

يحتوي هذا الدليل على المكونات الأساسية والأدوات المساعدة والخدمات المستخدمة في جميع أنحاء تطبيق متجر Genius.

## الغرض

دليل النواة:

- يوفر اللبنات الأساسية للتطبيق
- يحتوي على التكوين المركزي والثوابت
- ينفذ المخاوف المتقاطعة (معالجة الأخطاء، التسجيل، إلخ)
- يحتوي على الخدمات العالمية (التحليلات، الاتصال، إلخ)
- يحدد مكونات نظام التصميم المرئي
- يؤسس الأدوات المساعدة والمساعدين على مستوى التطبيق

## هيكل الدليل

```text
core/
├── config/            # تكوين التطبيق
├── constants/         # الثوابت على مستوى التطبيق
├── errors/            # معالجة الأخطاء والإبلاغ عنها
├── localization/      # الترجمة والتدويل
├── routes/            # التنقل والتوجيه
├── services/          # الخدمات العالمية
├── theme/             # نظام التصميم المرئي
└── utils/             # وظائف المساعدة والملحقات
```

## المكونات الرئيسية

### التكوين (Config)

يحتوي `config/` على تكوين التطبيق بأكمله:

- `app_config.dart`: التكوين الخاص بالبيئة (التطوير، الاختبار، الإنتاج)
- `firebase_config.dart`: تكوين Firebase وتهيئته
- `api_config.dart`: نقاط نهاية API وإعدادات الاتصال
- `storage_config.dart`: تكوين التخزين المحلي

يتم تحميل التكوين عند بدء تشغيل التطبيق:

```dart
Future<void> initConfig() async {
  final configMap = await loadConfigForEnvironment(Environment.production);
  AppConfig.instance.initialize(configMap);
}
```

### الثوابت (Constants)

يحدد `constants/` قيم الثوابت على مستوى التطبيق:

- `app_constants.dart`: ثوابت التطبيق العامة
- `asset_paths.dart`: مسارات الأصول الثابتة (الصور، الخطوط، إلخ)
- `api_constants.dart`: نقاط نهاية API والمفاتيح
- `route_constants.dart`: مسارات التنقل المسماة
- `regex_constants.dart`: أنماط التعبيرات العادية الشائعة
- `error_constants.dart`: رسائل وأكواد الخطأ

يتم الوصول إلى الثوابت في جميع أنحاء التطبيق:

```dart
// مثال على الاستخدام
Text(
  AppConstants.appName,
  style: Theme.of(context).textTheme.headline1,
)
```

### الأخطاء (Errors)

ينفذ `errors/` معالجة الأخطاء والإبلاغ عنها:

- `app_exception.dart`: فئة الاستثناء الأساسية للأخطاء الخاصة بالتطبيق
- `failure.dart`: فئة نتيجة الفشل لنمط Either
- `error_handler.dart`: معالجة الأخطاء المركزية
- `error_logger.dart`: خدمة تسجيل الأخطاء والإبلاغ عنها
- `network_exceptions.dart`: استثناءات خاصة بالشبكة

تتبع معالجة الأخطاء هذا النمط:

```dart
Future<Either<Failure, User>> signIn(String email, String password) async {
  try {
    final user = await _authDataSource.signIn(email, password);
    return Right(user);
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  } on CacheException catch (e) {
    return Left(CacheFailure(message: e.message));
  } catch (e) {
    return Left(UnexpectedFailure(message: e.toString()));
  }
}
```

### الترجمة (Localization)

يتعامل `localization/` مع الترجمة والتدويل:

- `app_localizations.dart`: مندوب الترجمة والوصول إلى السلاسل النصية
- `supported_locales.dart`: اللغات واللغات المحلية المدعومة
- `locale_provider.dart`: إدارة حالة اللغة المحلية
- `string_keys.dart`: ثوابت مفاتيح الترجمة
- `translations/`: ملفات الترجمة الخاصة باللغة

تستخدم الترجمة في جميع أنحاء التطبيق:

```dart
// الوصول إلى السلاسل النصية المترجمة
final String welcomeMessage = AppLocalizations.of(context).translate(StringKeys.welcome);

// تعيين لغة التطبيق المحلية
AppLocalizations.of(context).setLocale(Locale('es', 'ES'));
```

### المسارات (Routes)

يدير `routes/` التنقل والتوجيه:

- `app_router.dart`: تكوين جهاز التوجيه الرئيسي
- `route_observer.dart`: مراقب التنقل للتحليلات
- `route_guards.dart`: حراس التنقل للمصادقة
- `route_transitions.dart`: انتقالات المسار المخصصة
- `deep_link_handler.dart`: معالجة الروابط العميقة

يتم تنفيذ التنقل من خلال جهاز التوجيه:

```dart
// الانتقال إلى مسار مسمى
AppRouter.navigateTo(context, RouteConstants.productDetail, arguments: product);

// توليد تكوين المسار
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteConstants.home:
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case RouteConstants.productDetail:
      final product = settings.arguments as Product;
      return MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product));
    // مسارات أخرى...
    default:
      return MaterialPageRoute(builder: (_) => NotFoundScreen());
  }
}
```

### الخدمات (Services)

يوفر `services/` خدمات التطبيق العالمية:

- `analytics_service.dart`: تتبع الاستخدام والتحليلات
- `connectivity_service.dart`: مراقبة اتصال الشبكة
- `local_storage_service.dart`: تخزين محلي دائم
- `auth_service.dart`: المصادقة وإدارة المستخدم
- `permission_service.dart`: معالجة أذونات الجهاز
- `push_notification_service.dart`: إدارة الإشعارات الفورية
- `device_info_service.dart`: معلومات الجهاز وقدراته

يتم تهيئة الخدمات عند بدء تشغيل التطبيق والوصول إليها عبر حقن التبعيات:

```dart
// تهيئة الخدمة
await AnalyticsService.instance.initialize();

// استخدام الخدمة من خلال حقن التبعيات
final analyticsService = ref.watch(analyticsServiceProvider);
analyticsService.logEvent('product_viewed', {'product_id': product.id});
```

### السمة (Theme)

يحدد `theme/` نظام التصميم المرئي للتطبيق:

- `app_theme.dart`: تكوين السمة وإنشاؤها
- `color_palette.dart`: ألوان العلامة التجارية وتعريفات الألوان الدلالية
- `text_styles.dart`: تعريفات الطباعة
- `dimensions.dart`: ثوابت التباعد والحجم
- `app_icons.dart`: تعريفات الأيقونات المخصصة
- `decorations.dart`: زخارف وأنماط الصناديق الشائعة
- `input_decorations.dart`: تنسيق حقول الإدخال

يتم تطبيق تكوين السمة على MaterialApp:

```dart
MaterialApp(
  title: AppConstants.appName,
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeMode,
  // تكوين آخر...
)
```

### الأدوات المساعدة (Utils)

يحتوي `utils/` على وظائف وملحقات مساعدة:

- `date_utils.dart`: تنسيق التاريخ ومعالجته
- `string_utils.dart`: معالجة وتنسيق السلاسل النصية
- `validation_utils.dart`: مساعدات التحقق من صحة الإدخال
- `currency_formatter.dart`: تنسيق العملة
- `image_utils.dart`: أدوات معالجة الصور
- `device_utils.dart`: أدوات مساعدة خاصة بالجهاز
- `extensions/`: طرق ملحقة للأنواع المدمجة

تستخدم الأدوات المساعدة في جميع أنحاء التطبيق:

```dart
// تنسيق التاريخ
final formattedDate = DateUtils.formatDate(order.createdAt, 'MMM dd, yyyy');

// تنسيق العملة
final formattedPrice = CurrencyFormatter.format(product.price);

// استخدام ملحق السلسلة النصية
final truncatedText = productDescription.truncate(100);
```

## أنماط التصميم

تنفذ وحدة النواة العديد من أنماط التصميم:

### نمط المفرد (Singleton Pattern)

يستخدم للخدمات التي تحتاج إلى مثيل واحد في جميع أنحاء التطبيق:

```dart
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  
  factory AnalyticsService() => _instance;
  
  AnalyticsService._internal();
  
  static AnalyticsService get instance => _instance;
  
  // تنفيذ الخدمة...
}
```

### نمط المراقب (Observer Pattern)

يستخدم لتغييرات الحالة وإخطارات الأحداث:

```dart
class ConnectivityService {
  final _connectivitySubject = BehaviorSubject<ConnectivityStatus>();
  
  Stream<ConnectivityStatus> get connectivityStatusStream => _connectivitySubject.stream;
  
  // تنفيذ المراقب...
}
```
