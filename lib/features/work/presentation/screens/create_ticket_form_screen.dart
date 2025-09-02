import 'dart:developer';
import 'dart:io';

import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/utils/app_snack_bar.dart';
import 'package:dynamic_emr/core/utils/file_picker_utils.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/core/widgets/dropdown/custom_dropdown.dart';
import 'package:dynamic_emr/core/widgets/form/custom_date_time_field.dart';
import 'package:dynamic_emr/core/widgets/form/custom_input_field.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:dynamic_emr/features/work/domain/entities/business_client_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_categories_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';
import 'package:dynamic_emr/features/work/presentation/bloc/work_bloc.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/assign_to_dropdown_widget.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/business_client_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTicketFormScreen extends StatefulWidget {
  const CreateTicketFormScreen({super.key});

  @override
  State<CreateTicketFormScreen> createState() => _CreateTicketFormScreenState();
}

class _CreateTicketFormScreenState extends State<CreateTicketFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientDepartmentController =
      TextEditingController();
  final TextEditingController _clientUserController = TextEditingController();
  final TextEditingController _ticketDate = TextEditingController(
    text: DateTime.now().toIso8601String().split('T').first,
  );
  final TextEditingController _ticketDueDate = TextEditingController();

  int? _selectedCategoriesType;
  String? _selectedPriorityType;
  int? _selectedAssignToType;
  String? _selectedSeverityType;
  String? _selectedClient;

  DateTime? _selectedTicketDate, _selectedTicketDueDate;

  List<WorkUserEntity> workUserList = [];
  List<TicketCategoriesEntity> categoriesList = [];
  List<BusinessClientEntity> clientList = [];

  List<File> attachments = [];

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<WorkBloc>()
      ..add(TicketCategoriesEvent())
      ..add(WorkUserListEvent())
      ..add(BusinessClientEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _clientNameController.dispose();
    _clientDepartmentController.dispose();
    _clientUserController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _selectedCategoriesType = null;
      _selectedPriorityType = null;
      _selectedAssignToType = null;
      _selectedSeverityType = null;
      _ticketDueDate.clear();
      _titleController.clear();
      _descriptionController.clear();
      _clientUserController.clear();
      _clientDepartmentController.clear();
      _clientNameController.clear();
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      AppSnackBar.show(
        context,
        "Please fill all required fields correctly",
        SnackbarType.error,
      );
      log("Please fill all required fields correctly");
      return;
    }

    if (_selectedCategoriesType == null ||
        _selectedPriorityType == null ||
        _selectedAssignToType == null ||
        _selectedSeverityType == null) {
      log("Please select all dropdown values");
      return;
    }

    // Convert File objects to paths
    List<String> attachmentPaths = attachments
        .map((file) => file.path)
        .toList();

    log(attachmentPaths.toList().toString());

    context.read<WorkBloc>().add(
      CreateTicketEvent(
        ticketCategoryId: _selectedCategoriesType!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        severity: _selectedSeverityType!,
        priority: _selectedPriorityType!,
        assignToEmployeeId: _selectedAssignToType!,
        attachmentPaths: attachmentPaths,
        client: _selectedClient!,
        clientDesc: _clientDepartmentController.text.trim(),
        clientDesc2: _clientUserController.text.trim(),
        dueDate: _selectedTicketDueDate.toString(),
      ),
    );
    _resetForm();
  }

  Widget buildAttachmentButtons() {
    return Row(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAttachmentButton(
          icon: Icons.camera_alt,
          label: "Camera",
          color: Colors.blue.withValues(alpha: 0.6),
          onTap: () async {
            final result = await FilePickerUtils.pickImage(fromCamera: true);
            if (result.file != null) {
              setState(() => attachments.add(result.file!));
            } else if (result.error != null) {
              AppSnackBar.show(context, result.error!, SnackbarType.error);
            }
          },
        ),

        _buildAttachmentButton(
          icon: Icons.upload_file,
          label: "Gallery / File",
          color: Colors.green.withValues(alpha: 0.7),
          onTap: () async {
            final result = await FilePickerUtils.pickFile();
            if (result.file != null) {
              setState(() => attachments.add(result.file!));
            } else if (result.error != null) {
              AppSnackBar.show(context, result.error!, SnackbarType.error);
            }
          },
        ),
      ],
    );
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignToItems = workUserList
        .map(
          (user) => {
            'label': user.text,
            'value': int.parse(user.value.toString()),
          },
        )
        .toList();

    final categoriesItems = categoriesList
        .map(
          (category) => {
            'label': category.text,
            'value': int.parse(category.value.toString()),
          },
        )
        .toList();

    Widget buildSectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );

    return BlocListener<WorkBloc, WorkState>(
      listener: (context, state) {
        if (state.workStatus == WorkStatus.success) {
          setState(() {
            workUserList = state.workUser ?? [];
            categoriesList = state.ticketCategories ?? [];
            clientList = state.businessClient ?? [];
          });
        }
        if (state.workStatus == WorkStatus.createTicketSuccess) {
          AppSnackBar.show(
            context,
            "Ticket Created Successfully",
            SnackbarType.success,
          );
          Navigator.pop(context);
        }
        if (state.workStatus == WorkStatus.createTicketError) {
          AppSnackBar.show(
            context,
            "Ticket Created failed",
            SnackbarType.error,
          );
        }
      },
      child: Scaffold(
        appBar: DynamicEMRAppBar(
          title: 'Create New Ticket',
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
              onPressed: _resetForm,
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset Ticket Form',
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<LeaveBloc, LeaveState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Please provide all necessary details for your request or issue. Once submitted, your ticket will be assigned to particular employee, and you will be notified when there is an update or resolution.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.blue.shade800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      buildSectionTitle("Ticket Date"),
                      CustomDateTimeField(
                        controller: _ticketDate,
                        hintText: "Ticket Date *",
                        onChanged: (date) {
                          setState(() {
                            _selectedTicketDate = DateTime.parse(date);
                          });
                        },
                      ),

                      buildSectionTitle("Categories"),
                      CustomDropdown2(
                        value: _selectedCategoriesType,
                        items: categoriesItems,
                        hintText: "Select Ticket Categories *",
                        onChanged: (value) =>
                            setState(() => _selectedCategoriesType = value),
                      ),

                      buildSectionTitle("Title"),
                      CustomInputField(
                        controller: _titleController,
                        hintText: "Title for your ticket *",
                        maxLines: 1,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Title is required'
                            : null,
                      ),

                      buildSectionTitle("Description/Message"),
                      CustomInputField(
                        controller: _descriptionController,
                        hintText: "Description for your ticket *",
                        maxLines: 2,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Description is required'
                            : null,
                      ),

                      buildSectionTitle("Files/Images"),

                      buildAttachmentButtons(),

                      //  attachments list
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          ...attachments.map(
                            (file) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
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
                                      file.path.split('/').last,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        (attachments).remove(file);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildSectionTitle("Severity"),
                      CustomDropdown(
                        value: _selectedSeverityType,
                        items: ['Low', 'Medium', 'High'],
                        hintText: "Select Severity Type *",
                        onChanged: (value) =>
                            setState(() => _selectedSeverityType = value),
                      ),

                      buildSectionTitle("Priority"),
                      CustomDropdown(
                        value: _selectedPriorityType,
                        items: ['Low', 'Medium', 'High'],
                        hintText: "Select Priority Type *",
                        onChanged: (value) =>
                            setState(() => _selectedPriorityType = value),
                      ),

                      buildSectionTitle("Assigned To"),

                      AssignToDropdownWidget(
                        employee: assignToItems,
                        onSelected: (label, value) {
                          setState(() {
                            _selectedAssignToType = value;
                          });
                          log("Selected Employee: $label ($value)");
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select a colleague who can resolve this issues',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      buildSectionTitle("Client"),
                      BusinessClientDropdownWidget(
                        clients: clientList,
                        onSelected: (client) {
                          setState(() {
                            _selectedClient = client!.clientName;
                          });
                          log("Selected Client: $_selectedClient ");
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'issue by client',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      buildSectionTitle("Client Department"),
                      CustomInputField(
                        controller: _clientDepartmentController,
                        hintText: "Enter department",
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'issue by client department',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      buildSectionTitle("Client User"),
                      CustomInputField(
                        controller: _clientUserController,
                        hintText: "Enter user...",
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'issue by client user',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),

                      buildSectionTitle("Ticket Date"),
                      CustomDateTimeField(
                        controller: _ticketDueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        hintText: "Ticket Due Date",
                        onChanged: (date) {
                          setState(() {
                            _selectedTicketDueDate = DateTime.parse(date);
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: const Icon(Icons.send),
                          label: const Text(
                            'Create New Ticket',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
