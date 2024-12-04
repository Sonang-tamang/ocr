import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class FileDownloaderUtil {
  static Future<void> downloadFile(String url, String fileName) async {
    try {
      // Check and request storage permission
      if (!await _requestStoragePermission()) {
        print("Storage permission denied.");
        return;
      }

      // Fetch file from the URL
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        print("Failed to download: ${response.statusCode}");
        return;
      }

      // Save file to public Downloads folder
      final filePath = "/storage/emulated/0/Download/$fileName";
      await File(filePath).writeAsBytes(response.bodyBytes);
      print("File saved to: $filePath");
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.isGranted ||
        await Permission.manageExternalStorage.isGranted) {
      return true;
    }
    if (await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }
    if (await Permission.storage.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }
}
