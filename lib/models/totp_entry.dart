import 'package:hive/hive.dart';

part 'totp_entry.g.dart';

@HiveType(typeId: 4)
class TOTPEntry extends HiveObject {
  @HiveField(0)
  String issuer;

  @HiveField(1)
  String account;

  @HiveField(2)
  String secret;

  TOTPEntry({required this.issuer, required this.account, required this.secret});
}
