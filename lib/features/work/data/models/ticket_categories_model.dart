import 'package:dynamic_emr/features/work/domain/entities/ticket_categories_entity.dart';

class TicketCategoriesModel extends TicketCategoriesEntity {
  TicketCategoriesModel({required super.text, required super.value});

  factory TicketCategoriesModel.fromJson(Map<String, dynamic> json) =>
      TicketCategoriesModel(text: json['text'], value: json['value']);
}
