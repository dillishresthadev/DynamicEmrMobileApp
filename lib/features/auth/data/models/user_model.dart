import 'package:dynamic_emr/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.username, required super.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(username: json["Username"], password: json["Password"]);
  }

  Map<String, dynamic> toJson() {
    return {"Username": username, "Password": password};
  }
}
