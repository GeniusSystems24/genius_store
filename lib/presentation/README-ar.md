# طبقة العرض (Presentation Layer)

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)

تُنفّذ طبقة العرض واجهة المستخدم لتطبيق Genius Store. وهي تتبع نمط العمارة MVVM (النموذج-العرض-نموذج العرض) وتستخدم Riverpod لإدارة الحالة.

## الغرض

طبقة العرض:

- تعرض مكونات واجهة المستخدم والشاشات
- تتعامل مع تفاعلات المستخدم
- تدير حالة واجهة المستخدم من خلال ViewModels/Providers
- تتواصل مع طبقة المجال (Domain) من خلال حالات الاستخدام (Use Cases)
- تُنفّذ الجوانب المرئية للتطبيق بما في ذلك التخطيطات والرسوم المتحركة والتنقل

## هيكل الدليل

```text
presentation/
├── common_widgets/    # مكونات واجهة المستخدم القابلة لإعادة الاستخدام
├── screens/           # شاشات التطبيق منظمة حسب الميزة
│   ├── auth/          # شاشات المصادقة
│   ├── cart/          # شاشات سلة التسوق
│   ├── checkout/      # شاشات الدفع
│   ├── home/          # الشاشة الرئيسية
│   ├── product/       # شاشات المنتج
│   └── profile/       # شاشات الملف الشخصي
└── providers/         # إدارة الحالة باستخدام Riverpod
```

## نظرة عامة على العمارة

تتبع طبقة العرض نمط MVVM مع بعض التعديلات لـ Flutter و Riverpod:

```mermaid
---
config:
  look: classic
  layout: elk
---
flowchart TB
    subgraph Presentation Layer
        View["الشاشات والأدوات\n(العرض)"]
        ViewModel["Providers\n(نموذج العرض)"]
    end
    
    subgraph Domain Layer
        UseCase["حالات الاستخدام"]
        Entities["الكيانات"]
    end
    
    View L_View_ViewModel_0@<--> |يراقب ويحدث| ViewModel
    ViewModel L_ViewModel_UseCase_0@<--> |يستدعي ويستقبل| UseCase
    UseCase L_UseCase_Entities_0@--> |يعالج| Entities
    View L_View_Entities_0@--> |يعرض| Entities
    
    linkStyle 0 stroke:#1E88E5,fill:none,stroke-width:2px
    linkStyle 1 stroke:#42A5F5,fill:none,stroke-width:2px
    linkStyle 2 stroke:#FFA000,fill:none,stroke-width:2px
    linkStyle 3 stroke:#4CAF50,fill:none,stroke-width:2px
    
    L_View_ViewModel_0@{ animation: fast }
    L_ViewModel_UseCase_0@{ animation: fast } 
    L_UseCase_Entities_0@{ animation: fast } 
    L_View_Entities_0@{ animation: fast }
```

### المكونات

#### العرض (الشاشات والأدوات)

- مكونات واجهة المستخدم التي تعرض المعلومات للمستخدم
- تعالج مدخلات المستخدم وتوجهها إلى نماذج العرض
- تراقب تغييرات الحالة من Providers وتعيد البناء وفقًا لذلك
- تنفذ منطق واجهة المستخدم (الرسوم المتحركة، الانتقالات، إلخ.)

#### نموذج العرض (Providers)

- تغلف حالة واجهة المستخدم ومنطق الأعمال
- تتواصل مع طبقة المجال من خلال حالات الاستخدام
- تعالج وتحول البيانات للعرض
- تتعامل مع إدارة الحالة باستخدام Riverpod
- تتوسط بين طبقات العرض والمجال

## إدارة الحالة مع Riverpod

يستخدم التطبيق Riverpod لإدارة الحالة نظرًا لمزاياه:

- حقن التبعية ونمط محدد موقع الخدمة
- إعادة البناء الفعالة مع تفاعلية دقيقة
- قابلية الاختبار من خلال استبدال Provider
- تكامل سلس مع العمليات غير المتزامنة

### هيكل Provider

```mermaid
---
config:
  look: classic
  layout: elk
---
flowchart TD
    FP["Future/Stream Providers\n(تحميل البيانات غير المتزامن)"] L_FP_SP_0@--> |يغذي البيانات إلى| SP["State Notifier Providers\n(الحالة المتغيرة)"]
    SP L_SP_P_0@--> |يوفر الحالة لـ| P["Regular Providers\n(الحالة للقراءة فقط)"]
    P L_P_UI_0@--> |يحدث| UI["مكونات واجهة المستخدم"]
    FP L_FP_UI_0@--> |يحدث مباشرة| UI
    
    linkStyle 0 stroke:#1E88E5,fill:none,stroke-width:2px
    linkStyle 1 stroke:#42A5F5,fill:none,stroke-width:2px
    linkStyle 2 stroke:#4CAF50,fill:none,stroke-width:2px
    linkStyle 3 stroke:#FFA000,fill:none,stroke-width:2px
    
    L_FP_SP_0@{ animation: fast }
    L_SP_P_0@{ animation: fast } 
    L_P_UI_0@{ animation: fast } 
    L_FP_UI_0@{ animation: fast }
```

### أنواع Provider

- **State Notifier Providers**: للحالة المتغيرة (مثل عناصر سلة التسوق)
- **Future/Stream Providers**: للعمليات غير المتزامنة (مثل جلب المنتجات)
- **Regular Providers**: للحالة البسيطة أو الحسابات (مثل القوائم المفلترة)

## التنقل

يستخدم التطبيق نظام التنقل بالمسارات المسماة لـ Flutter:

- يتم تعريف المسارات في فئة `AppRouter`
- يتم تنفيذ التنقل باستخدام `Navigator.pushNamed` والطرق ذات الصلة
- يتم تمرير وسيطات المسار إلى الشاشات عبر المعلمة `settings.arguments`

## نظام التصميم

تتبع طبقة العرض نظام تصميم متسق:

- تكوين السمة من `core/theme`
- المكونات القابلة لإعادة الاستخدام في `common_widgets`
- مسافات وطباعة وألوان متسقة

## أفضل الممارسات

يتبع التنفيذ أفضل الممارسات التالية:

1. **فصل المخاوف**: لا تحتوي مكونات واجهة المستخدم على منطق الأعمال
2. **المسؤولية الفردية**: لكل مكون غرض واضح ومركز
3. **إعادة الاستخدام**: يتم استخراج الأدوات الشائعة لإعادة استخدامها
4. **قابلية الاختبار**: يتم فصل المنطق عن واجهة المستخدم لتسهيل الاختبار
5. **الاتساق**: يتم تنفيذ أنماط واجهة المستخدم المماثلة بشكل متسق
6. **الاستجابة**: تتكيف واجهة المستخدم مع أحجام الشاشات المختلفة واتجاهاتها
