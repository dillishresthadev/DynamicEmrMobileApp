import 'package:dynamic_emr/features/auth/domain/entities/user_branch_entity.dart';


class UserBranchModel extends UserBranchEntity {
  const UserBranchModel({required super.branchId, required super.branchName});

  factory UserBranchModel.fromJson(Map<String, dynamic> json) {
    return UserBranchModel(
      branchId: json['branchId'] as int,
      branchName: json['branchName'] as String,
    );
  }

}
