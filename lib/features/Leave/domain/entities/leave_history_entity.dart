class LeaveHistoryEntity {
  final String leaveType;
  final double allocated;
  final double taken;
  final double balance;
  final DateTime fromDate;
  final DateTime toDate;
  final String fromDateNp;
  final String toDateNp;

  LeaveHistoryEntity({
    required this.leaveType,
    required this.allocated,
    required this.taken,
    required this.balance,
    required this.fromDate,
    required this.toDate,
    required this.fromDateNp,
    required this.toDateNp,
  });
}
