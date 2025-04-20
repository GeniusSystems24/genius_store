class CategoryModel {
  final String id;
  final Map<String, String> nameLocalized;
  final String? parentId;
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.nameLocalized,
    this.parentId,
    required this.imageUrl,
  });

  String getName(String languageCode) {
    return nameLocalized[languageCode] ?? nameLocalized['en'] ?? '';
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      nameLocalized: Map<String, String>.from(json['name_localized']),
      parentId: json['parent_id'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_localized': nameLocalized,
      'parent_id': parentId,
      'image_url': imageUrl,
    };
  }
}
