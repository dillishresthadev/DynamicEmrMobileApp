import 'package:dynamic_emr/features/attendance/domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  AttendanceModel({required super.category, required super.qty});
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      category: json['category'],
      qty: (json['qty'] is int)
          ? json['qty'] as int
          : (json['qty'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'category': category, 'qty': qty};
  }
}
