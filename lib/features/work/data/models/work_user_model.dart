import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';

class WorkUserModel extends WorkUserEntity {
  WorkUserModel({required super.text, required super.value});

  factory WorkUserModel.fromJson(Map<String, dynamic> json) =>
      WorkUserModel(text: json['text'], value: json['value']);
}
