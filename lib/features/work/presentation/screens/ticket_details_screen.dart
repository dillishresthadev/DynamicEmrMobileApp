import 'dart:io';

import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/utils/app_snack_bar.dart';
import 'package:dynamic_emr/core/utils/file_picker_utils.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/core/widgets/form/custom_input_field.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_activity_entity.dart';
import 'package:dynamic_emr/features/work/presentation/bloc/work_bloc.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/ticket_file_widget.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/ticket_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

class TicketDetailsScreen extends StatefulWidget {
  final int ticketId;
  const TicketDetailsScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();

  List<File> commentAttachments = [];

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
                _commentController.clear();
                commentAttachments = [];
                return Center(child: CircularProgressIndicator());
              } else if (state.workStatus ==
                      WorkStatus.ticketDetailsLoadSuccess ||
                  state.workStatus == WorkStatus.success) {
                final ticket = state.ticketDetails;
                final users = state.workUser;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ticket Info
                      TicketInfoWidget(
                        ticket: ticket!.ticket,
                        user: users ?? [],
                      ),

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
                              // ticket title and descriptions
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.ticket.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // Rending HTML tags as ticket may comes from web too
                                  Html(
                                    data: ticket.ticket.description,
                                    style: {
                                      "*": Style(
                                        fontSize: FontSize(14),
                                        color: Colors.black87,
                                      ),
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // ticket initial file or images
                              TicketFilesWidget(
                                attachedDocuments:
                                    ticket.ticket.attachedDocuments,
                                baseUrl: ticket.baseUrl ?? '',
                              ),
                              const SizedBox(height: 20),
                              _buildTimeline(
                                ticketActivity: ticket.ticketActivity,
                                baseUrl: ticket.baseUrl ?? '',
                              ),
                              const SizedBox(height: 20),
                              // comment on ticket
                              CustomInputField(
                                hintText: "Comments message",
                                controller: _commentController,
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    final result =
                                        await FilePickerUtils.pickImage(
                                          fromCamera: true,
                                        );
                                    if (result.file != null) {
                                      setState(
                                        () => commentAttachments.add(
                                          result.file!,
                                        ),
                                      );
                                    } else if (result.error != null) {
                                      AppSnackBar.show(
                                        context,
                                        result.error!,
                                        SnackbarType.error,
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.camera_alt_outlined),
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  ...commentAttachments.map(
                                    (file) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2.0,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.insert_drive_file,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              file.path.split('_').last,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blue,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                (commentAttachments).remove(
                                                  file,
                                                );
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: Icon(
                                        Icons.comment,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        "Comment",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_commentController.text
                                            .trim()
                                            .isEmpty) {
                                          AppSnackBar.show(
                                            context,
                                            "Your comment message is empty",
                                            SnackbarType.error,
                                          );
                                        } else {
                                          // Convert File objects to paths
                                          List<String> attachmentPaths =
                                              commentAttachments
                                                  .map((file) => file.path)
                                                  .toList();
                                          context.read<WorkBloc>().add(
                                            CommentOnTicketEvent(
                                              ticketId: ticket.id,
                                              message: _commentController.text,
                                              attachmentPaths: attachmentPaths,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  // close or reopen
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        final shouldProceed = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog.adaptive(
                                            title: const Text("Confirm Action"),
                                            content: Text(
                                              ticket.ticket.status == "Open"
                                                  ? "Are you sure you want to close this ticket?"
                                                  : "Are you sure you want to re-open this ticket?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                  context,
                                                ).pop(true),

                                                child: const Text("Yes"),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (shouldProceed == true) {
                                          if (ticket.ticket.status == "Open") {
                                            context.read<WorkBloc>().add(
                                              TicketClosedEvent(
                                                ticketId: ticket.id,
                                              ),
                                            );
                                          } else {
                                            context.read<WorkBloc>().add(
                                              TicketReopenEvent(
                                                ticketId: ticket.id,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      icon: Icon(
                                        ticket.ticket.status == "Open"
                                            ? Icons.close
                                            : Icons.refresh,
                                        color: Colors.white,
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
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(child: Text("Unknown State : $state"));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline({
    required List<TicketActivityEntity> ticketActivity,
    required String baseUrl,
  }) {
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
            time: DateFormat(
              'EE dd MMM, yyyy hh:mm a',
            ).format(activity.replyOn),
            isFirst: index == 0,
            isLast: index == ticketActivity.length - 1,
            attachedDocs: activity.attachedDocuments,
            baseUrl: baseUrl,
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
    required List<String> attachedDocs,
    required String baseUrl,
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
                  Column(
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
                        ],
                      ),
                      Text(time, style: TextStyle(fontSize: 12)),
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
                      child: Html(
                        data: subtitle,
                        style: {
                          "*": Style(
                            margin: Margins.all(0),
                            fontSize: FontSize(13),
                            color: Colors.grey[700],
                          ),
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  // show attachments in ticket activity with preview options
                  if (attachedDocs.isNotEmpty) ...[
                    TicketFilesWidget(
                      attachedDocuments: attachedDocs,
                      baseUrl: baseUrl,
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
