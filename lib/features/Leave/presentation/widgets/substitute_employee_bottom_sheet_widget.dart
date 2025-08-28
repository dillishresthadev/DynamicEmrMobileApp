import 'package:dynamic_emr/core/widgets/form/custom_input_field.dart';
import 'package:flutter/material.dart';

class SubstituteEmployeeBottomSheetWidget extends StatefulWidget {
  final List<Map<String, dynamic>> substituteEmployee;

  final Function(String label, int value) onSelected;

  const SubstituteEmployeeBottomSheetWidget({
    super.key,
    required this.substituteEmployee,
    required this.onSelected,
  });

  @override
  State<SubstituteEmployeeBottomSheetWidget> createState() =>
      _SubstituteEmployeeBottomSheetWidgetState();
}

class _SubstituteEmployeeBottomSheetWidgetState
    extends State<SubstituteEmployeeBottomSheetWidget> {
  String? _selectedSubstituteEmployeeText;
  int? selectedSubstituteEmployeeValue;

  void _openSubstituteEmployeeBottomSheetWidget() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<Map<String, dynamic>> filteredSubstituteEmployee = List.from(
          widget.substituteEmployee,
        );

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                              filteredSubstituteEmployee = widget
                                  .substituteEmployee
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
                            itemCount: filteredSubstituteEmployee.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final user = filteredSubstituteEmployee[index];
                              final userLabel = user['label'] ?? "Unknown";
                              final userValue = user['value'] ?? -1;

                              return ListTile(
                                title: Text(userLabel),
                                onTap: () {
                                  setState(() {
                                    _selectedSubstituteEmployeeText = userLabel;
                                    selectedSubstituteEmployeeValue = userValue;
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
      onTap: _openSubstituteEmployeeBottomSheetWidget,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            hintText: _selectedSubstituteEmployeeText ?? "Select employee...",
            readOnly: true,
            onTap: _openSubstituteEmployeeBottomSheetWidget,
          ),
        ],
      ),
    );
  }
}
