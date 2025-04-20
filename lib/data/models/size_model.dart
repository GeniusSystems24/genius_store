class SizeModel {
  final String id;
  final Map<String, String> nameLocalized;

  SizeModel({
    required this.id,
    required this.nameLocalized,
  });

  String getName(String languageCode) {
    return nameLocalized[languageCode] ?? nameLocalized['en'] ?? '';
  }

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['id'],
      nameLocalized: Map<String, String>.from(json['name_localized']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_localized': nameLocalized,
    };
  }
}
