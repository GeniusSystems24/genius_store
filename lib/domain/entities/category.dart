import 'package:equatable/equatable.dart';

/// كيان التصنيف في طبقة الأعمال المنطقية
class Category extends Equatable {
  final String id;
  final Map<String, String> nameLocalized;
  final String? parentId;
  final String imageUrl;

  const Category({
    required this.id,
    required this.nameLocalized,
    this.parentId,
    required this.imageUrl,
  });

  String getName(String languageCode) {
    return nameLocalized[languageCode] ?? nameLocalized['en'] ?? '';
  }

  @override
  List<Object?> get props => [
        id,
        nameLocalized,
        parentId,
        imageUrl,
      ];
}
