import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_document_entity.dart';
import 'package:flutter/material.dart';

class DocumentViewerScreen extends StatelessWidget {
  final EmployeeDocumentEntity document;
  final String url;

  const DocumentViewerScreen({
    super.key,
    required this.document,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicEMRAppBar(
        title: document.documentType ?? "Document",
        automaticallyImplyLeading: true,
      ),
      body: InteractiveViewer(
        constrained: true, // keeps child inside viewport initially
        clipBehavior: Clip.none,
        minScale: 1.0, // 100% (no smaller than natural size)
        maxScale: 4.0, // zoom up to 4x
        child: Center(
          child: Image.network(
            "$url/${document.attachmentPath}",
            fit: BoxFit.contain, // scale image to fit inside screen
            loadingBuilder:
                (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.error, color: Colors.red, size: 40),
            ),
          ),
        ),
      ),
    );
  }
}
