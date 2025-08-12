import 'package:hive/hive.dart';

part 'secure_note.g.dart';

@HiveType(typeId: 3)
class SecureNote extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  SecureNote({
    required this.title,
    required this.content,
  });
}