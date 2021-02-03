import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String name;

  @HiveField(1)
  String token;

  @HiveField(2)
  String id;

  User(this.name, this.token, this.id);
}
