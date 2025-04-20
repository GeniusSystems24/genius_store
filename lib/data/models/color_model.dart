class ColorModel {
  final String id;
  final Map<String, String> nameLocalized;
  final String hexCode;

  ColorModel({
    required this.id,
    required this.nameLocalized,
    required this.hexCode,
  });

  String getName(String languageCode) {
    return nameLocalized[languageCode] ?? nameLocalized['en'] ?? '';
  }

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['id'],
      nameLocalized: Map<String, String>.from(json['name_localized']),
      hexCode: json['hex_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_localized': nameLocalized,
      'hex_code': hexCode,
    };
  }
}
