import 'package:hive/hive.dart';

part 'user.g.dart'; // This will be generated

@HiveType(typeId: 7) // Choose a unique ID (0 is fine if unused)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String accessToken;

  User({
   required this.id,
    required this.username, // Changed field name
    required this.accessToken // Changed field name
    });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString()??'',//Handle Null
      username: json['username']as String? ?? '',//Match backend field
      accessToken: json['accessToken']as String? ??'', // match backend field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'username':username,//update key name
        'accessToken':accessToken//update key name
       };
  }
}
