// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:ocr/components/downloader.dart';
import 'package:ocr/components/pdf.dart';
import 'package:path_provider/path_provider.dart';

class Scaner extends StatefulWidget {
  const Scaner({super.key});

  @override
  State<Scaner> createState() => _ScanerState();
}

class _ScanerState extends State<Scaner> {
  dynamic _scanDocument;
  String? filepath;
  String? downloadedFilePath;

  bool checkFileExists(String path) {
    final file = File(path);
    return file.existsSync();
  }

  Future<void> scanFunction() async {
    dynamic scannedDocument;
    try {
      scannedDocument =
          await FlutterDocScanner().getScanDocuments() ?? "Unknown Platform";
    } on PlatformException {
      _scanDocument = 'Fail to get scanned Document';
    }

    if (!mounted) return;

    setState(() {
      _scanDocument = scannedDocument;
    });

    // Extract the file path from the scanned document
    if (scannedDocument is Map && scannedDocument.containsKey('pdfUri')) {
      final String? pdfUri = scannedDocument['pdfUri'];
      if (pdfUri != null && pdfUri.startsWith('file://')) {
        setState(() {
          filepath =
              pdfUri.replaceFirst('file://', ''); // Remove "file://" prefix
        });
        print("File path updated to: $filepath");
      }
      print("Received file pdfUri: $pdfUri");
    }

    print("Scan result: $scannedDocument");
  }

  Future<void> savePDFLocally(String pdfUri) async {
    try {
      // Get the app's document directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final String savePath = '${directory.path}/downloaded_file.pdf';

      if (pdfUri.startsWith('file://')) {
        // Remove "file://" prefix and handle as a local file path
        final sourcePath = pdfUri.replaceFirst('file://', '');
        final sourceFile = File(sourcePath);
        final destinationFile = File(savePath);

        if (await sourceFile.exists()) {
          await sourceFile.copy(destinationFile.path);
          print('File successfully copied to: $savePath');
        } else {
          print('Source file does not exist.');
        }
      } else {
        // If `pdfUri` is not a local file URI, handle it differently
        print('This function only handles local file URIs.');
      }
    } catch (e) {
      print('Error saving file locally: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  scanFunction();
                },
                child: Text(
                  "Scan ",
                  style: TextStyle(color: Colors.black),
                )),
            ElevatedButton(
              onPressed: () {
                if (filepath != null) {
                  savePDFLocally(filepath!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('No file path available. Please scan first.')),
                  );
                }
              },
              child: Text('Save PDF Locally'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (filepath != null && filepath!.isNotEmpty) {
                  if (checkFileExists(filepath!)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PDFViewerScreen(pdfPath: filepath!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "PDF file not found. Ensure the scan is complete."),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "File path is null or invalid. Please scan first."),
                    ),
                  );
                }
              },
              child: Text("View PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
