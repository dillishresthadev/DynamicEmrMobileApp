import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/work_bloc.dart';

class AssignToBottomSheetWidget extends StatefulWidget {
  final List<WorkUserEntity> users;
  final TicketEntity ticket;

  const AssignToBottomSheetWidget({
    super.key,
    required this.users,
    required this.ticket,
  });

  @override
  State<AssignToBottomSheetWidget> createState() =>
      _AssignToBottomSheetWidgetState();
}

class _AssignToBottomSheetWidgetState extends State<AssignToBottomSheetWidget> {
  String? _selectedUserText;

  void _openAssignToBottomSheetWidget() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<WorkUserEntity> filteredUsers = List.from(widget.users);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // handle keyboard
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return StatefulBuilder(
                builder: (context, setModalState) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Assign To",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 🔍 Search field
                          TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: "Search user...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setModalState(() {
                                filteredUsers = widget.users
                                    .where(
                                      (u) => u.text.toLowerCase().contains(
                                        value.toLowerCase(),
                                      ),
                                    )
                                    .toList();
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // 📃 User List
                          ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              return ListTile(
                                title: Text(user.text),
                                onTap: () {
                                  setState(() {
                                    _selectedUserText = user.text;
                                  });

                                  context.read<WorkBloc>().add(
                                    EditAssignToEvent(
                                      ticketId: widget.ticket.id,
                                      assignedUserId: int.parse(user.value),
                                    ),
                                  );

                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openAssignToBottomSheetWidget,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Assign To",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedUserText ?? widget.ticket.assignedTo,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _selectedUserText == null
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.edit, size: 16, color: Colors.blueGrey),
                ],
              ),
            ],
          ),
          const Divider(height: 12, thickness: 0.5),
        ],
      ),
    );
  }
}
