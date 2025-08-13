import 'dart:io';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from camera or gallery
  /// fromCamera: true = camera, false = gallery
  /// maxSizeInMB: file size limit
  static Future<File?> pickImage({
    required bool fromCamera,
    double maxSizeInMB = 2,
  }) async {
    try {
      XFile? pickedFile;
      if (fromCamera) {
        pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 2000,
          maxWidth: 2000,
          imageQuality: 85,
        );
      } else {
        pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 2000,
          maxWidth: 2000,
          imageQuality: 85,
        );
      }

      if (pickedFile == null) return null;

      final file = File(pickedFile.path);

      if (!_validateFile(file, ['jpg', 'jpeg', 'png'], maxSizeInMB)) {
        return null;
      }

      return file;
    } catch (e) {
      log('Image pick error: $e');
      return null;
    }
  }

  /// Pick any file
  /// allowedExtensions: list of allowed file types
  /// maxSizeInMB: file size limit
  static Future<File?> pickFile({
    List<String> allowedExtensions = const ['jpg', 'jpeg', 'png', 'pdf'],
    double maxSizeInMB = 2,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = File(result.files.first.path!);

      if (!_validateFile(file, allowedExtensions, maxSizeInMB)) return null;

      return file;
    } catch (e) {
      log('File pick error: $e');
      return null;
    }
  }

  /// Validate file extension and size
  static bool _validateFile(
    File file,
    List<String> allowedExtensions,
    double maxSizeInMB,
  ) {
    final fileSize = file.lengthSync();
    final fileExtension = file.path.split('.').last.toLowerCase();

    if (!allowedExtensions.contains(fileExtension)) {
      log('Unsupported file type: $fileExtension');
      return false;
    }

    if (fileSize > maxSizeInMB * 1024 * 1024) {
      log('File size exceeds $maxSizeInMB MB');
      return false;
    }

    return true;
  }
}
