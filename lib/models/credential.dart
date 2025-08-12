import 'package:hive/hive.dart';

part 'credential.g.dart';

@HiveType(typeId: 0)
class Credential extends HiveObject {
  @HiveField(0)
  final String site;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String password;

  Credential({required this.site, required this.username, required this.password});
}
