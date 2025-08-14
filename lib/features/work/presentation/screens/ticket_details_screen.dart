import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_activity_entity.dart';
import 'package:dynamic_emr/features/work/presentation/bloc/work_bloc.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/ticket_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TicketDetailsScreen extends StatefulWidget {
  final int ticketId;
  const TicketDetailsScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkBloc>().add(
        TicketDetailsByIdEvent(ticketId: widget.ticketId),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DynamicEMRAppBar(
        title: "Ticket Details",
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<WorkBloc>().add(
            TicketDetailsByIdEvent(ticketId: widget.ticketId),
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<WorkBloc, WorkState>(
            builder: (context, state) {
              if (state.workStatus == WorkStatus.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.workStatus ==
                  WorkStatus.ticketDetailsLoadSuccess) {
                final ticket = state.ticketDetails;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ticket Info
                    TicketInfoWidget(ticket: ticket!.ticket),
                    // Ticket Timeline Card
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Ticket Timeline',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),

                                // close or reopen
                                ElevatedButton.icon(
                                  onPressed: () {
                                    ticket.ticket.status == "Open"
                                        ? context.read<WorkBloc>().add(
                                            TicketClosedEvent(
                                              ticketId: ticket.id,
                                            ),
                                          )
                                        : context.read<WorkBloc>().add(
                                            TicketReopenEvent(
                                              ticketId: ticket.id,
                                            ),
                                          );

                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    ticket.ticket.status == "Open"
                                        ? Icons.close
                                        : Icons.refresh,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  label: Text(
                                    ticket.ticket.status == "Open"
                                        ? 'Close'
                                        : 'Reopen',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ticket.ticket.status == "Open"
                                        ? Colors.red
                                        : Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildTimeline(
                              ticketActivity: ticket.ticketActivity,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Center(child: Text("Unknown State : $state"));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline({required List<TicketActivityEntity> ticketActivity}) {
    if (ticketActivity.isEmpty) {
      return const Center(child: Text("No activity found"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red[500],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              DateFormat(
                'dd MMM, yyyy',
              ).format(ticketActivity.first.commentDate),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Timeline Items from API
        ...ticketActivity.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;

          // Pick icon & color based on activity type
          IconData icon;
          Color iconColor;
          if (activity.activity.toLowerCase().contains("status")) {
            icon = Icons.check_circle_outline;
            activity.ticketAction.contains("re-opened")
                ? iconColor = Colors.red
                : iconColor = Colors.green;
          } else if (activity.comment != null) {
            icon = Icons.comment_outlined;
            iconColor = Colors.orange;
          } else {
            icon = Icons.info_outline;
            iconColor = Colors.blue;
          }

          return _buildTimelineItem(
            icon: icon,
            iconColor: iconColor,
            title: "${activity.replyBy} ${activity.ticketAction}".trim(),
            subtitle: activity.comment ?? "",
            time: DateFormat('M/d/yyyy h:mm:ss a').format(activity.replyOn),
            isFirst: index == 0,
            isLast: index == ticketActivity.length - 1,
          );
        }),
      ],
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and icon
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst)
                  Container(width: 2, height: 12, color: Colors.grey[300]),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: iconColor.withValues(alpha: 0.3)),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: Colors.grey[300])),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${title.split(' ').first} ', // First word
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: title
                                    .split(' ')
                                    .skip(1)
                                    .join(' '), // Remaining text
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
