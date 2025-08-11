import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';

class LeaveHistoryModel extends LeaveHistoryEntity {
  LeaveHistoryModel({
    required super.leaveType,
    required super.allocated,
    required super.taken,
    required super.balance,
    required super.fromDate,
    required super.toDate,
    required super.fromDateNp,
    required super.toDateNp,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryModel(
      leaveType: json['leaveType'],
      allocated: (json['allocated'] as num).toDouble(),
      taken: (json['taken'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      fromDateNp: json['fromDateNp'],
      toDateNp: json['toDateNp'],
    );
  }
}
