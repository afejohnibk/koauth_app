import 'package:hive/hive.dart';

part 'card_info.g.dart';

@HiveType(typeId: 2)
class CardInfo extends HiveObject {
  @HiveField(0)
  String cardholderName;

  @HiveField(1)
  String cardNumber;

  @HiveField(2)
  String expiryDate;

  @HiveField(3)
  String cvv;

  CardInfo({
    required this.cardholderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });
}