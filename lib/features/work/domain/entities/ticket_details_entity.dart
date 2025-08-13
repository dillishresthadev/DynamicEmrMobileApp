import 'package:dynamic_emr/features/work/domain/entities/ticket_activity_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';

class TicketDetailsEntity {
  final int id;
  final TicketEntity ticket;
  final List<TicketActivityEntity> ticketActivity;
  final bool isTicketUser;
  final String? baseUrl;

  TicketDetailsEntity({
    required this.id,
    required this.ticket,
    required this.ticketActivity,
    required this.isTicketUser,
     this.baseUrl,
  });
}
