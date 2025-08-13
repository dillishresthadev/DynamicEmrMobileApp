import 'dart:developer';
import 'dart:io';

import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/utils/file_picker_utils.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/core/widgets/dropdown/custom_dropdown.dart';
import 'package:dynamic_emr/core/widgets/form/custom_input_field.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_categories_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';
import 'package:dynamic_emr/features/work/presentation/bloc/work_bloc.dart';
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

  int? _selectedCategoriesType;
  String? _selectedPriorityType;
  int? _selectedAssignToType;
  String? _selectedSeverityType;

  List<WorkUserEntity> workUserList = [];
  List<TicketCategoriesEntity> categoriesList = [];

  List<File> attachments = [];

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<WorkBloc>()
      ..add(TicketCategoriesEvent())
      ..add(WorkUserListEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _selectedCategoriesType = null;
      _selectedPriorityType = null;
      _selectedAssignToType = null;
      _selectedSeverityType = null;
      _titleController.clear();
      _descriptionController.clear();
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
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

    context.read<WorkBloc>().add(
      CreateTicketEvent(
        ticketCategoryId: _selectedCategoriesType!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        severity: _selectedSeverityType!,
        priority: _selectedPriorityType!,
        assignToEmployeeId: _selectedAssignToType!,
        attachmentPaths: attachmentPaths,
      ),
    );
    _resetForm();
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
      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );

    return BlocListener<WorkBloc, WorkState>(
      listener: (context, state) {
        if (state.workStatus == WorkStatus.success) {
          setState(() {
            workUserList = state.workUser ?? [];
            categoriesList = state.ticketCategories ?? [];
          });
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
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                          hintText: "Please provide a title for your ticket *",
                          maxLines: 1,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Title is required'
                              : null,
                        ),

                        buildSectionTitle("Description/Message"),
                        CustomInputField(
                          controller: _descriptionController,
                          hintText:
                              "Please provide a description for your ticket *",
                          maxLines: 2,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Description is required'
                              : null,
                        ),
                        buildSectionTitle("Files/Images"),

                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                final file = await FilePickerUtils.pickImage(
                                  fromCamera: true,
                                );
                                if (file != null) {
                                  setState(() {
                                    attachments.add(file);
                                  });
                                }
                              },
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
                            ),

                            ElevatedButton.icon(
                              onPressed: () async {
                                final file = await FilePickerUtils.pickFile();
                                if (file != null) {
                                  setState(() {
                                    attachments.add(file);
                                  });
                                }
                              },
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Gallery / File'),
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
                        CustomDropdown2(
                          value: _selectedAssignToType,
                          items: assignToItems,
                          hintText: "Select Employee",
                          onChanged: (value) =>
                              setState(() => _selectedAssignToType = value),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select a colleague who can resolve this issues',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
