import 'package:dynamic_emr/features/work/domain/entities/ticket_activity_entity.dart';

class TicketDetailsEntity {
  final int id;
  final TicketDetailsEntity ticketDetails;
  final List<TicketActivityEntity> ticketActivity;
  final bool isTicketUser;
  final String? baseUrl;

  TicketDetailsEntity({
    required this.id,
    required this.ticketDetails,
    required this.ticketActivity,
    required this.isTicketUser,
    required this.baseUrl,
  });
}
