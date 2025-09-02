import 'package:dynamic_emr/core/widgets/form/custom_input_field.dart';
import 'package:dynamic_emr/features/work/domain/entities/business_client_entity.dart';
import 'package:flutter/material.dart';

class BusinessClientDropdownWidget extends StatefulWidget {
  final List<BusinessClientEntity> clients;
  final Function(BusinessClientEntity? selectedClient) onSelected;

  const BusinessClientDropdownWidget({
    super.key,
    required this.clients,
    required this.onSelected,
  });

  @override
  State<BusinessClientDropdownWidget> createState() =>
      _BusinessClientDropdownWidgetState();
}

class _BusinessClientDropdownWidgetState
    extends State<BusinessClientDropdownWidget> {
  String? _selectedClientName;

  void _openClientDropdown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<BusinessClientEntity> filteredClients = List.from(widget.clients);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
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
                          "Select Client",
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
                            hintText: "Search client...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setModalState(() {
                              filteredClients = widget.clients
                                  .where(
                                    (client) => client.clientName
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()),
                                  )
                                  .toList();
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        // Client list
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: filteredClients.length,
                            itemBuilder: (context, index) {
                              final client = filteredClients[index];
                              final name = client.clientName;

                              return ListTile(
                                title: Text(name),
                                onTap: () {
                                  setState(() {
                                    _selectedClientName = name;
                                  });

                                  widget.onSelected(client);
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
      onTap: _openClientDropdown,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            hintText: _selectedClientName ?? "Select client...",
            readOnly: true,
            onTap: _openClientDropdown,
          ),
        ],
      ),
    );
  }
}
