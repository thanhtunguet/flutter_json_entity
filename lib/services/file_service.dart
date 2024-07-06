import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FileService {
  static bool isOfficeFile(String filename) {
    return filename.endsWith('.doc') ||
        filename.endsWith('.docx') ||
        filename.endsWith('.xls') ||
        filename.endsWith('.xlsx') ||
        filename.endsWith('.ppt') ||
        filename.endsWith('.pptx');
  }

  static bool isDocFile(String filename) {
    return filename.endsWith('.doc') || filename.endsWith('.docx');
  }

  static bool isSpreadSheetFile(String filename) {
    return filename.endsWith('.xls') || filename.endsWith('.xlsx');
  }

  static bool isPresentationFile(String filename) {
    return filename.endsWith('.ppt') || filename.endsWith('.pptx');
  }

  static bool isImageFile(String filename) {
    return filename.endsWith('.jpg') || filename.endsWith('.jpeg') || filename.endsWith('.png');
  }

  static bool isPDFFile(String filename) {
    return filename.endsWith('.pdf');
  }

  static Future<void> launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  static String createOfficeViewerUrl(String fileUrl) {
    fileUrl = Uri.encodeComponent(fileUrl);
    return 'https://view.officeapps.live.com/op/view.aspx?src=$fileUrl';
  }

  static String createGoogleDocsViewerUrl(String fileUrl) {
    fileUrl = Uri.encodeComponent(fileUrl);
    return 'https://docs.google.com/gview?embedded=true&url=$fileUrl';
  }

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
