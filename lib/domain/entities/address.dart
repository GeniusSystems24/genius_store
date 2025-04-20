import 'package:equatable/equatable.dart';

/// كيان العنوان في طبقة الأعمال المنطقية
class Address extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String phone;
  final bool isDefault;

  const Address({
    required this.id,
    required this.userId,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.phone,
    required this.isDefault,
  });

  String get fullAddress => '$street, $city, $state, $country, $postalCode';

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        street,
        city,
        state,
        country,
        postalCode,
        phone,
        isDefault,
      ];
}
