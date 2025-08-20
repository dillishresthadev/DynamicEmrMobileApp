import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/employee_details/document_viewer_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_document_entity.dart';

class EmployeeDocumentScreen extends StatefulWidget {
  const EmployeeDocumentScreen({super.key});

  @override
  State<EmployeeDocumentScreen> createState() => _EmployeeDocumentScreenState();
}

class _EmployeeDocumentScreenState extends State<EmployeeDocumentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DynamicEMRAppBar(
        title: "Employee Documents",
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.employeeStatus == ProfileStatus.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading documents...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (state.employeeStatus == ProfileStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.employeeMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ProfileBloc>().add(
                        GetEmployeeDetailsEvent(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.employeeStatus == ProfileStatus.loaded) {
            final documents = state.employee!.employeeDocuments;
            final documnetBaseUrl = state.employee!.documentBaseUrl;

            if (documents.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No Documents Available",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "No employee documents found in the system.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(GetEmployeeContractEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  final hasExpiry = document.expiryDate != null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: EnhancedDocumentCard(
                      document: document,
                      documentBaseUrl: documnetBaseUrl,
                      hasExpiry: hasExpiry,
                      documentIndex: index + 1,
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class EnhancedDocumentCard extends StatelessWidget {
  final EmployeeDocumentEntity document;
  final String documentBaseUrl;
  final bool hasExpiry;
  final int documentIndex;

  const EnhancedDocumentCard({
    super.key,
    required this.document,
    required this.documentBaseUrl,
    required this.hasExpiry,
    required this.documentIndex,
  });

  Color getDocumentTypeColor() {
    switch (document.documentType?.toLowerCase()) {
      case 'pan':
        return Colors.blue;
      case 'citizenship':
        return Colors.green;
      case 'passport':
        return Colors.purple;
      case 'license':
        return Colors.orange;
      case 'certificate':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData getDocumentTypeIcon() {
    switch (document.documentType?.toLowerCase()) {
      case 'pan':
        return Icons.credit_card;
      case 'citizenship':
        return Icons.person;
      case 'passport':
        return Icons.flight;
      case 'license':
        return Icons.drive_eta;
      case 'certificate':
        return Icons.school;
      default:
        return Icons.description;
    }
  }

  String getFileExtension() {
    if (document.attachmentPath!.isEmpty) return '';
    final parts = document.attachmentPath?.split('.');
    return parts!.length > 1 ? parts.last.toLowerCase() : '';
  }

  IconData getFileTypeIcon() {
    final extension = getFileExtension();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color getFileTypeColor() {
    final extension = getFileExtension();
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.green;
      case 'doc':
      case 'docx':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showDocumentViewer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          DocumentViewerDialogWidget(document: document, url: documentBaseUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    final documentTypeColor = getDocumentTypeColor();

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () => _showDocumentViewer(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with document number and document type
                Row(
                  spacing: 10,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: documentTypeColor.withValues(alpha: 0.1),
                      child: Icon(
                        getDocumentTypeIcon(),
                        color: documentTypeColor,
                        size: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Doc #${document.documentNumber} / ${document.documentType ?? 'None'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const Spacer(),

                    Icon(Icons.visibility, size: 18, color: Colors.grey[600]),
                  ],
                ),
                const SizedBox(height: 12),

                // Issue Information
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Issue Information',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Issue Date',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  document.issueDateNp ?? "None",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Issue Place',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  document.issuePlace ?? "None",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                // Expiry Information (if available)
                if (hasExpiry) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: document.days! <= 30 && document.days! >= 0
                          ? Colors.orange.withValues(alpha: 0.1)
                          : document.days! < 0
                          ? Colors.red.withValues(alpha: 0.1)
                          : Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          document.days! < 0
                              ? Icons.error
                              : document.days! <= 30
                              ? Icons.warning
                              : Icons.check_circle,
                          size: 16,
                          color: document.days! < 0
                              ? Colors.red[700]
                              : document.days! <= 30
                              ? Colors.orange[700]
                              : Colors.green[700],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expiry Date',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                document.expiryDateNp ?? 'Not specified',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: document.days! < 0
                                ? Colors.red
                                : document.days! <= 30
                                ? Colors.orange
                                : Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            document.days! < 0
                                ? 'Expired'
                                : document.days == 0
                                ? 'Today'
                                : '${document.days} days',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
