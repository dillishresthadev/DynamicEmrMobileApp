class EmployeePunchEntity {
  final int employeeId;
  final DateTime punchTime;
  final String? punchTimeNp;
  final String? logType;
  final bool skipAutoAttendence;
  final String? deviceId;
  final String? employee;
  final int id;
  final String insertUser;
  final DateTime insertTime;
  final String? updateUser;
  final DateTime? updateTime;
  final bool isDeleted;
  final String? deletedBy;
  final DateTime? deletedOn;
  final int? branchId;
  final String? branch;
  final String? dimension1;
  final String? dimension2;
  final String systemDtl;
  final dynamic extra;

  EmployeePunchEntity({
    required this.employeeId,
    required this.punchTime,
    required this.punchTimeNp,
    required this.logType,
    required this.skipAutoAttendence,
    required this.deviceId,
    required this.employee,
    required this.id,
    required this.insertUser,
    required this.insertTime,
    required this.updateUser,
    required this.updateTime,
    required this.isDeleted,
    required this.deletedBy,
    required this.deletedOn,
    required this.branchId,
    required this.branch,
    required this.dimension1,
    required this.dimension2,
    required this.systemDtl,
    required this.extra,
  });
}
