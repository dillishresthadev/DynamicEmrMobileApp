class AttendanceDetailsEntity {
  final DateTime attendanceDate;
  final String attendanceDateNp;
  final String employeeName;
  final String? departmentName;
  final String dutyType;
  final String shiftTitle;
  final String shiftTime;
  final DateTime shiftStartTime;
  final DateTime shiftEndTime;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final DateTime? breakOutTime;
  final DateTime? breakInTime;
  final String? status;
  final String? remarks;
  final String statusFullName;
  final String statusColorCode;

  AttendanceDetailsEntity({
    required this.attendanceDate,
    required this.attendanceDateNp,
    required this.employeeName,
    required this.departmentName,
    required this.dutyType,
    required this.shiftTitle,
    required this.shiftTime,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.checkInTime,
    required this.checkOutTime,
    required this.breakOutTime,
    required this.breakInTime,
    required this.status,
    required this.remarks,
    required this.statusFullName,
    required this.statusColorCode,
  });
}
