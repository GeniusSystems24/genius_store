import 'package:equatable/equatable.dart';

/// كيان اللون في طبقة الأعمال المنطقية
class Color extends Equatable {
  final String id;
  final Map<String, String> nameLocalized;
  final String hexCode;

  const Color({
    required this.id,
    required this.nameLocalized,
    required this.hexCode,
  });

  String getName(String languageCode) {
    return nameLocalized[languageCode] ?? nameLocalized['en'] ?? '';
  }

  @override
  List<Object?> get props => [
        id,
        nameLocalized,
        hexCode,
      ];
}
