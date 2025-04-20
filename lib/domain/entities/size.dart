import 'package:equatable/equatable.dart';

/// كيان المقاس في طبقة الأعمال المنطقية
class Size extends Equatable {
  final String id;
  final Map<String, String> nameLocalized;

  const Size({
    required this.id,
    required this.nameLocalized,
  });

  String getName(String languageCode) {
    return nameLocalized[languageCode] ?? nameLocalized['en'] ?? '';
  }

  @override
  List<Object?> get props => [
        id,
        nameLocalized,
      ];
}
