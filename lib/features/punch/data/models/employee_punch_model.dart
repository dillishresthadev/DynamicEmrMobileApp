import 'package:dynamic_emr/features/punch/domain/entities/employee_punch_entity.dart';

class EmployeePunchModel extends EmployeePunchEntity {
  EmployeePunchModel({
    required super.employeeId,
    required super.punchTime,
    required super.punchTimeNp,
    required super.logType,
    required super.skipAutoAttendence,
    required super.deviceId,
    required super.employee,
    required super.id,
    required super.insertUser,
    required super.insertTime,
    required super.updateUser,
    required super.updateTime,
    required super.isDeleted,
    required super.deletedBy,
    required super.deletedOn,
    required super.branchId,
    required super.branch,
    required super.dimension1,
    required super.dimension2,
    required super.systemDtl,
    required super.extra,
  });

  factory EmployeePunchModel.fromJson(Map<String, dynamic> json) {
    return EmployeePunchModel(
      employeeId: json['employeeId'] as int,
      punchTime: DateTime.parse(json['punchTime'] as String),
      punchTimeNp: json['punchTimeNp'] as String?,
      logType: json['logType'] as String?,
      skipAutoAttendence: json['skipAutoAttendence'] as bool,
      deviceId: json['deviceId'] as String?,
      employee: json['employee'] as String?,
      id: json['id'] as int,
      insertUser: json['insertUser'] as String,
      insertTime: DateTime.parse(json['insertTime'] as String),
      updateUser: json['updateUser'] as String?,
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'] as String)
          : null,
      isDeleted: json['isDeleted'] as bool,
      deletedBy: json['deletedBy'] as String?,
      deletedOn: json['deletedOn'] != null
          ? DateTime.parse(json['deletedOn'] as String)
          : null,
      branchId: json['branchId'] as int?,
      branch: json['branch'] as String?,
      dimension1: json['dimension1'] as String?,
      dimension2: json['dimension2'] as String?,
      systemDtl: json['systemDtl'] as String,
      extra: json['extra'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'punchTime': punchTime.toIso8601String(),
      'punchTimeNp': punchTimeNp,
      'logType': logType,
      'skipAutoAttendence': skipAutoAttendence,
      'deviceId': deviceId,
      'employee': employee,
      'id': id,
      'insertUser': insertUser,
      'insertTime': insertTime.toIso8601String(),
      'updateUser': updateUser,
      'updateTime': updateTime?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedBy': deletedBy,
      'deletedOn': deletedOn?.toIso8601String(),
      'branchId': branchId,
      'branch': branch,
      'dimension1': dimension1,
      'dimension2': dimension2,
      'systemDtl': systemDtl,
      'extra': extra,
    };
  }
}
