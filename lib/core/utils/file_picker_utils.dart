import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<FileResult> pickImage({
    required bool fromCamera,
    double maxSizeInMB = 2,
  }) async {
    try {
      XFile? pickedFile = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 2000,
        maxWidth: 2000,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return FileResult(error: "No image selected");
      }

      final file = File(pickedFile.path);

      final error = _validateFile(file, ['jpg', 'jpeg', 'png'], maxSizeInMB);
      if (error != null) return FileResult(error: error);

      return FileResult(file: file);
    } catch (e) {
      return FileResult(error: "Image pick error: $e");
    }
  }

  static Future<FileResult> pickFile({
    List<String> allowedExtensions = const ['jpg', 'jpeg', 'png', 'pdf'],
    double maxSizeInMB = 2,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result == null || result.files.isEmpty) {
        return FileResult(error: "No file selected");
      }

      final file = File(result.files.first.path!);

      final error = _validateFile(file, allowedExtensions, maxSizeInMB);
      if (error != null) return FileResult(error: error);

      return FileResult(file: file);
    } catch (e) {
      return FileResult(error: "File pick error: $e");
    }
  }

  /// return `null` if valid, else error message
  static String? _validateFile(
    File file,
    List<String> allowedExtensions,
    double maxSizeInMB,
  ) {
    final fileSize = file.lengthSync();
    final fileExtension = file.path.split('.').last.toLowerCase();

    if (!allowedExtensions.contains(fileExtension)) {
      return 'Unsupported file type: $fileExtension';
    }

    if (fileSize > maxSizeInMB * 1024 * 1024) {
      return 'File size exceeds $maxSizeInMB MB';
    }

    return null;
  }
}

class FileResult {
  final File? file;
  final String? error;

  FileResult({this.file, this.error});
}
