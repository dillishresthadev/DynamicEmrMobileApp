import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class TicketFilesWidget extends StatelessWidget {
  final List<String> attachedDocuments;
  final String baseUrl;

  const TicketFilesWidget({
    super.key,
    required this.attachedDocuments,
    required this.baseUrl,
  });

  bool _isImage(String fileName) {
    final lower = fileName.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif');
  }

  bool _isPdf(String fileName) => fileName.toLowerCase().endsWith('.pdf');

  bool _isVideo(String fileName) {
    final lower = fileName.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mkv');
  }

  bool _isExcel(String fileName) {
    final lower = fileName.toLowerCase();
    return lower.endsWith('.xls') ||
        lower.endsWith('.xlsx') ||
        lower.endsWith('.csv');
  }

  bool _isWord(String fileName) {
    final lower = fileName.toLowerCase();
    return lower.endsWith('.doc') || lower.endsWith('.docx');
  }

  bool _isAudio(String fileName) {
    final lower = fileName.toLowerCase();
    return lower.endsWith('.mp3') ||
        lower.endsWith('.wav') ||
        lower.endsWith('.aac');
  }

  IconData _getFileIcon(String fileName) {
    if (_isImage(fileName)) return Icons.image;
    if (_isPdf(fileName)) return Icons.picture_as_pdf;
    if (_isVideo(fileName)) return Icons.videocam;
    if (_isExcel(fileName)) return Icons.grid_on;
    if (_isWord(fileName)) return Icons.description;
    if (_isAudio(fileName)) return Icons.audiotrack;
    return Icons.insert_drive_file; // generic file
  }

  Color _getFileColor(String fileName) {
    if (_isImage(fileName)) return Colors.blue;
    if (_isPdf(fileName)) return Colors.red;
    if (_isVideo(fileName)) return Colors.purple;
    if (_isExcel(fileName)) return Colors.green;
    if (_isWord(fileName)) return Colors.blueGrey;
    if (_isAudio(fileName)) return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (attachedDocuments.isEmpty) return SizedBox.shrink();

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attachedDocuments.length,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          final fileName = attachedDocuments[index];
          final fileUrl = "$baseUrl/$fileName";

          if (_isImage(fileName)) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullScreenImageViewer(imageUrl: fileUrl),
                ),
              ),
              child: _filePreviewIcon(fileName),
            );
          } else if (_isPdf(fileName)) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PdfViewerPage(pdfUrl: fileUrl, fileName: fileName),
                ),
              ),
              child: _filePreviewIcon(fileName),
            );
          } else {
            // All other files open with system default app
            return GestureDetector(
              onTap: () async {
                final path = await _downloadFile(fileUrl, fileName);
                if (path != null) await OpenFile.open(path);
              },
              child: _filePreviewIcon(fileName),
            );
          }
        },
      ),
    );
  }

  Widget _filePreviewIcon(String fileName) {
    return Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getFileIcon(fileName),
            size: 40,
            color: _getFileColor(fileName),
          ),
          SizedBox(height: 8),
          Text(
            fileName,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Future<String?> _downloadFile(String url, String fileName) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      final dio = Dio();
      await dio.download(url, file.path);
      return file.path;
    } catch (_) {
      return null;
    }
  }
}

// ============ IMAGE VIEWER ============
class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============ PDF VIEWER ============
class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String fileName;

  const PdfViewerPage({
    super.key,
    required this.pdfUrl,
    required this.fileName,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;
  bool loading = true;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.fileName}');
      final dio = Dio();

      await dio.download(
        widget.pdfUrl,
        file.path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = received / total;
            });
          }
        },
      );

      setState(() {
        localPath = file.path;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fileName)),
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress > 0 ? progress : null,
                  ),
                  SizedBox(height: 10),
                  Text('${(progress * 100).toStringAsFixed(0)}%'),
                ],
              ),
            )
          : PDFView(
              filePath: localPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            ),
    );
  }
}
