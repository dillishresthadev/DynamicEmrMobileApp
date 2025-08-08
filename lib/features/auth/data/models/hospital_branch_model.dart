import 'package:dynamic_emr/features/auth/domain/entities/hospital_branch_entity.dart';

class HospitalBranchModel extends HospitalBranchEntity {
  const HospitalBranchModel({
    required super.branchId,
    required super.branchName,
  });

  factory HospitalBranchModel.fromJson(Map<String, dynamic> json) {
    return HospitalBranchModel(
      branchId: json['branchId'] as int,
      branchName: json['branchName'] as String,
    );
  }
}
