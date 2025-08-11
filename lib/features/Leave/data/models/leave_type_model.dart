import 'package:dynamic_emr/features/Leave/domain/entities/leave_type_entity.dart';

class LeaveTypeModel extends LeaveTypeEntity {
  LeaveTypeModel({required super.text, required super.value});
  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(text: json['text'], value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'value': value};
  }
}
