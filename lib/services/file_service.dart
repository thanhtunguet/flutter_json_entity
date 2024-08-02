import 'package:flutter/material.dart';
import 'package:supa_carbon_icons/supa_carbon_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// A service class for handling file-related operations.
///
/// Provides methods for determining file types, launching URLs, creating
/// viewer URLs for office and Google Docs, and retrieving appropriate icons
/// for different file types.
class FileService {
  /// Checks if the given filename corresponds to an office file.
  ///
  /// **Parameters:**
  /// - `filename`: The name of the file to check.
  ///
  /// **Returns:**
  /// - A boolean indicating whether the file is an office file.
  static bool isOfficeFile(String filename) {
    return filename.endsWith('.doc') ||
        filename.endsWith('.docx') ||
        filename.endsWith('.xls') ||
        filename.endsWith('.xlsx') ||
        filename.endsWith('.ppt') ||
        filename.endsWith('.pptx');
  }

  /// Checks if the given filename corresponds to a document file.
  ///
  /// **Parameters:**
  /// - `filename`: The name of the file to check.
  ///
  /// **Returns:**
  /// - A boolean indicating whether the file is a document file.
  static bool isDocFile(String filename) {
    return filename.endsWith('.doc') || filename.endsWith('.docx');
  }

  /// Checks if the given filename corresponds to a spreadsheet file.
  ///
  /// **Parameters:**
  /// - `filename`: The name of the file to check.
  ///
  /// **Returns:**
  /// - A boolean indicating whether the file is a spreadsheet file.
  static bool isSpreadSheetFile(String filename) {
    return filename.endsWith('.xls') || filename.endsWith('.xlsx');
  }

  /// Checks if the given filename corresponds to a presentation file.
  ///
  /// **Parameters:**
  /// - `filename`: The name of the file to check.
  ///
  /// **Returns:**
  /// - A boolean indicating whether the file is a presentation file.
  static bool isPresentationFile(String filename) {
    return filename.endsWith('.ppt') || filename.endsWith('.pptx');
  }

  /// Checks if the given filename corresponds to an image file.
  ///
  /// **Parameters:**
  /// - `filename`: The name of the file to check.
  ///
  /// **Returns:**
  /// - A boolean indicating whether the file is an image file.
  static bool isImageFile(String filename) {
    return filename.endsWith('.jpg') ||
        filename.endsWith('.jpeg') ||
        filename.endsWith('.png');
  }

  /// Checks if the given filename corresponds to a PDF file.
  ///
  /// **Parameters:**
  /// - `filename`: The name of the file to check.
  ///
  /// **Returns:**
  /// - A boolean indicating whether the file is a PDF file.
  static bool isPDFFile(String filename) {
    return filename.endsWith('.pdf');
  }

  /// Launches the specified URL using the default web browser.
  ///
  /// **Parameters:**
  /// - `url`: The URL to be launched.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the URL has been launched.
  static Future<void> launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  /// Creates a URL for viewing an office file using the Microsoft Office web viewer.
  ///
  /// **Parameters:**
  /// - `fileUrl`: The URL of the office file to be viewed.
  ///
  /// **Returns:**
  /// - A string representing the viewer URL.
  static String createOfficeViewerUrl(String fileUrl) {
    fileUrl = Uri.encodeComponent(fileUrl);
    return 'https://view.officeapps.live.com/op/view.aspx?src=$fileUrl';
  }

  /// Creates a URL for viewing a file using the Google Docs web viewer.
  ///
  /// **Parameters:**
  /// - `fileUrl`: The URL of the file to be viewed.
  ///
  /// **Returns:**
  /// - A string representing the viewer URL.
  static String createGoogleDocsViewerUrl(String fileUrl) {
    fileUrl = Uri.encodeComponent(fileUrl);
    return 'https://docs.google.com/gview?embedded=true&url=$fileUrl';
  }

  /// Retrieves the appropriate icon for the given filename.
  ///
  /// **Parameters:**
  /// - `filename`: The name of the file for which the icon is to be retrieved.
  ///
  /// **Returns:**
  /// - The [IconData] representing the icon for the file.
  static IconData iconData(String filename) {
    if (filename.endsWith('.pdf')) {
      return CarbonIcons.pdf;
    }
    if (filename.endsWith('doc') || filename.endsWith('docx')) {
      return CarbonIcons.doc;
    }
    if (filename.endsWith('ppt') || filename.endsWith('pptx')) {
      return CarbonIcons.ppt;
    }
    if (filename.endsWith('xls') || filename.endsWith('xlsx')) {
      return CarbonIcons.xls;
    }
    if (filename.endsWith('zip')) {
      return CarbonIcons.zip;
    }
    if (filename.endsWith('txt')) {
      return CarbonIcons.txt;
    }
    if (filename.endsWith('jpg') ||
        filename.endsWith('jpeg') ||
        filename.endsWith('png') ||
        filename.endsWith('gif') ||
        filename.endsWith('bmp') ||
        filename.endsWith('webp')) {
      return CarbonIcons.image;
    }
    return Icons.attachment;
  }

  /// Checks if the given filename corresponds to a supported file type.
  ///
  /// **Parameters:**
  /// - `filename`: The name of the file to check.
  ///
  /// **Returns:**
  /// - A boolean indicating whether the file is a supported file type.
  static bool isSupportedFile(String filename) {
    // Define supported file extensions
    const supportedExtensions = [
      'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', // Image files
      'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', // Office files
      'pdf', // PDF files
      'zip', // Zip files
      'txt' // Text files
    ];
    // Get the file extension
    final fileExtension = filename.split('.').last.toLowerCase();
    // Check if the file extension is in the list of supported extensions
    return supportedExtensions.contains(fileExtension);
  }
}
