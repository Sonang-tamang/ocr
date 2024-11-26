import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class FileDownloader extends StatefulWidget {
  const FileDownloader({super.key});

  @override
  State<FileDownloader> createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  bool _isLoading = false;
  String _status = "Ready to download";

  Future<void> downloadFile(String url, String fileName) async {
    setState(() {
      _isLoading = true;
      _status = "Downloading...";
    });

    try {
      // Check and request storage permission
      if (!await _requestStoragePermission()) {
        setState(() => _status = "Storage permission denied.");
        return;
      }

      // Fetch file from the URL
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        setState(() => _status = "Failed to download: ${response.statusCode}");
        return;
      }

      // Save file to public Downloads folder
      final filePath = "/storage/emulated/0/Download/$fileName";
      await File(filePath).writeAsBytes(response.bodyBytes);
      setState(() => _status = "File saved to: $filePath");
    } catch (e) {
      setState(() => _status = "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _requestStoragePermission() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Downloader")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () => downloadFile(
                  "https://ocr.goodwish.com.np/media/converted_document/tamangsonang321-2024-11-25_094937.docx", // Replace with your URL
                  "sample 44.docx",
                ),
                child: const Text("Download to Public Storage"),
              ),
      ),
    );
  }
}
