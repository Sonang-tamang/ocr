import 'package:hive/hive.dart';

part 'login_data.g.dart';

@HiveType(typeId: 0)
class LoginData extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  @HiveField(3)
  String firstName;

  @HiveField(4)
  String lastName;

  @HiveField(5)
  String photo;

  @HiveField(6)
  String contact;

  @HiveField(7)
  String token;

  LoginData({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.photo,
    required this.contact,
    required this.token,
  });
}
