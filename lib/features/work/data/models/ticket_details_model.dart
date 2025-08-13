import 'package:dynamic_emr/features/work/data/models/ticket_activity_model.dart';
import 'package:dynamic_emr/features/work/data/models/ticket_model.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_details_entity.dart';

class TicketDetailsModel extends TicketDetailsEntity {
  TicketDetailsModel({
    required super.id,
    required super.ticket,
    required super.ticketActivity,
    required super.isTicketUser,
    super.baseUrl,
  });

  factory TicketDetailsModel.fromJson(Map<String, dynamic> json) =>
      TicketDetailsModel(
        id: json["id"] ?? 0,
        ticket: TicketModel.fromJson(json["ticket"] ?? {}),
        ticketActivity: json["ticketActivity"] != null
            ? List<TicketActivityModel>.from(
                json["ticketActivity"].map(
                  (x) => TicketActivityModel.fromJson(x ?? {}),
                ),
              )
            : <TicketActivityModel>[],
        isTicketUser: json["isTicketUser"] ?? false,
        baseUrl: json["baseUrl"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ticket": (ticket as TicketModel).toJson(),
    "ticketActivity": List<TicketActivityModel>.from(
      ticketActivity.map((x) => (x as TicketActivityModel).toJson()),
    ),
    "isTicketUser": isTicketUser,
    "baseUrl": baseUrl,
  };
}
