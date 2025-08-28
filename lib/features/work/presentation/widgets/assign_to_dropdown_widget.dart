import 'package:dynamic_emr/core/widgets/form/custom_input_field.dart';
import 'package:flutter/material.dart';

class AssignToDropdownWidget extends StatefulWidget {
  final List<Map<String, dynamic>> employee;

  final Function(String label, int value) onSelected;

  const AssignToDropdownWidget({
    super.key,
    required this.employee,
    required this.onSelected,
  });

  @override
  State<AssignToDropdownWidget> createState() => _AssignToDropdownWidgetState();
}

class _AssignToDropdownWidgetState extends State<AssignToDropdownWidget> {
  String? _selectedemployeeText;
  int? selectedemployeeValue;

  void _openAssignToDropdownWidget() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<Map<String, dynamic>> filteredemployee = List.from(
          widget.employee,
        );

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom +16,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return StatefulBuilder(
                builder: (context, setModalState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Substitute Employee",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 🔍 Search field (fixed at top)
                        TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "Search employee...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setModalState(() {
                              filteredemployee = widget.employee
                                  .where(
                                    (u) => (u['label'] as String)
                                        .toLowerCase()
                                        .contains(value.toLowerCase()),
                                  )
                                  .toList();
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Employee List
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount:
                                filteredemployee.length +
                                1, // +1 for "Select One"
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // First option = Clear selection
                                return ListTile(
                                  title: const Text("-- Select One --"),
                                  onTap: () {
                                    setState(() {
                                      _selectedemployeeText = null;
                                      selectedemployeeValue = null;
                                    });

                                    widget.onSelected(
                                      "",
                                      -1,
                                    ); // send empty/invalid
                                    Navigator.pop(context);
                                  },
                                );
                              }

                              // Normal employees
                              final user = filteredemployee[index - 1];
                              final userLabel = user['label'] ?? "Unknown";
                              final userValue = user['value'] ?? -1;

                              return ListTile(
                                title: Text(userLabel),
                                onTap: () {
                                  setState(() {
                                    _selectedemployeeText = userLabel;
                                    selectedemployeeValue = userValue;
                                  });

                                  widget.onSelected(userLabel, userValue);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      ],
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
      onTap: _openAssignToDropdownWidget,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            hintText: _selectedemployeeText ?? "Select employee...",
            readOnly: true,
            onTap: _openAssignToDropdownWidget,
          ),
        ],
      ),
    );
  }
}
