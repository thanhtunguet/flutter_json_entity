import "dart:io";

import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:supa_carbon_icons/supa_carbon_icons.dart";
import "package:url_launcher/url_launcher_string.dart";

/// A service class for handling file-related operations.
///
/// Provides methods for determining file types, launching URLs, creating
/// viewer URLs for office and Google Docs, and retrieving appropriate icons
/// for different file types.
class FileService {
  // Utility method to check if a file has a specific extension
  static bool _hasExtension(String filename, List<String> extensions) {
    final extension = filename.split(".").last.toLowerCase();
    return extensions.contains(extension);
  }

  /// Checks if the given filename corresponds to an office file.
  static bool isOfficeFile(String filename) {
    return _hasExtension(
        filename, ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx']);
  }

  /// Checks if the given filename corresponds to a document file.
  static bool isDocFile(String filename) {
    return _hasExtension(filename, ['doc', 'docx']);
  }

  /// Checks if the given filename corresponds to a spreadsheet file.
  static bool isSpreadSheetFile(String filename) {
    return _hasExtension(filename, ['xls', 'xlsx']);
  }

  /// Checks if the given filename corresponds to a presentation file.
  static bool isPresentationFile(String filename) {
    return _hasExtension(filename, ['ppt', 'pptx']);
  }

  /// Checks if the given filename corresponds to an image file.
  static bool isImageFile(String filename) {
    return _hasExtension(filename, ['jpg', 'jpeg', 'png', 'webp', 'bmp']);
  }

  static bool isVideoFile(String filename) {
    return _hasExtension(
      filename,
      ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm'],
    );
  }

  /// Checks if the given filename corresponds to a PDF file.
  static bool isPDFFile(String filename) {
    return _hasExtension(filename, ['pdf']);
  }

  /// Launches the specified URL using the default web browser.
  static Future<void> launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  /// Creates a URL for viewing an office file using the Microsoft Office web viewer.
  static String createOfficeViewerUrl(String fileUrl) {
    return "https://view.officeapps.live.com/op/view.aspx?src=${Uri.encodeComponent(fileUrl)}";
  }

  /// Creates a URL for viewing a file using the Google Docs web viewer.
  static String createGoogleDocsViewerUrl(String fileUrl) {
    return "https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(fileUrl)}";
  }

  /// Retrieves the appropriate icon for the given filename.
  static IconData iconData(String filename) {
    if (_hasExtension(filename, ['pdf'])) {
      return CarbonIcons.pdf;
    }
    if (_hasExtension(filename, ['doc', 'docx'])) {
      return CarbonIcons.doc;
    }
    if (_hasExtension(filename, ['ppt', 'pptx'])) {
      return CarbonIcons.ppt;
    }
    if (_hasExtension(filename, ['xls', 'xlsx'])) {
      return CarbonIcons.xls;
    }
    if (_hasExtension(filename, ['zip'])) {
      return CarbonIcons.zip;
    }
    if (_hasExtension(filename, ['txt'])) {
      return CarbonIcons.txt;
    }
    if (_hasExtension(filename, ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'])) {
      return CarbonIcons.image;
    }
    return Icons.attachment;
  }

  /// Checks if the given filename corresponds to a supported file type.
  static bool isSupportedFile(String filename) {
    const supportedExtensions = [
      'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', // Image files
      'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', // Office files
      'mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm', // Video files
      'pdf', // PDF files
      'zip', // Zip files
      'txt' // Text files
    ];
    return _hasExtension(filename, supportedExtensions);
  }

  static Future<void> clearTempDir() async {
    final tempDir = await getTemporaryDirectory();
    final files = tempDir.listSync();
    int i = 0;
    for (final file in files) {
      try {
        debugPrint("Deleting ${file.path}");
        if (file is File || file is Directory) {
          await file.delete(recursive: true);
        }
        i++;
      } catch (_) {
        ///
      }
    }
    debugPrint("Deleted $i files");
  }

  static Future<void> listFilesSync(
    Directory directory, {
    String prefix = "File:",
  }) async {
    final files = directory.listSync(recursive: true);
    for (final file in files) {
      debugPrint("$prefix ${file.path}");
    }
  }

  static Future<double> getDirectorySize(Directory directory) async {
    final files = directory.listSync(recursive: true);
    double size = 0;
    for (final file in files) {
      if (file is File) {
        size += file.lengthSync();
      }
    }
    return size;
  }
}
