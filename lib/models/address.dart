import 'package:hive/hive.dart';

part 'address.g.dart';

@HiveType(typeId: 1)
class Address extends HiveObject {
  @HiveField(0)
  String label;

  @HiveField(1)
  String street;

  @HiveField(2)
  String city;

  @HiveField(3)
  String state;

  @HiveField(4)
  String postalCode;

  @HiveField(5)
  String country;

  Address({
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });
}