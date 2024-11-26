// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';

import 'package:permission_handler/permission_handler.dart'; // Import this package to use jsonDecode

class PdfToDoc extends StatefulWidget {
  const PdfToDoc({super.key});

  @override
  State<PdfToDoc> createState() => _PdfToDocState();
}

class _PdfToDocState extends State<PdfToDoc> {
  File? _pdfFile;
  String? _convertedFileUrl;
  bool _isLoading = false;
  String? _error;
  bool isfilepicked = false;
  String _status = "Ready to download";

  // API########################
  final String apiUrl = 'https://ocr.goodwish.com.np/api/pdf-to-docx/';
  final String token =
      'e523b1bdc7f498148990d8c4cd9119a814c8daa0'; // my token in fluter ###############

  // Method to pick files ##############################################

  Future<void> pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      print("file is picked ");
      setState(() {
        _pdfFile = File(result.files.single.path!);
        isfilepicked = true;
        _convertedFileUrl = null;
        _error = null;
      });
    }
  }

  // Convert the file to DOCX
  Future<void> _convertFile() async {
    if (_pdfFile == null) {
      setState(() {
        _error = "Please upload a PDF file to convert.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _convertedFileUrl = null;
      _error = null;
    });

    try {
      // Prepare the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers['Authorization'] = 'Token $token'
        ..files.add(await http.MultipartFile.fromPath('file', _pdfFile!.path));

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        print("respons 200");
        // Read the response body as a string
        var responseBody = await response.stream.bytesToString();

        // Parse the responseBody (which is a string) to a Map
        final Map<String, dynamic> responseData = jsonDecode(responseBody);

        // Get the relative document path
        final String relativeDocumentPath = responseData['document'];

        // Construct the full URL by concatenating the base URL with the relative path
        final String baseUrl =
            'https://ocr.goodwish.com.np'; // Ensure this matches your server's base URL
        final String fullDocumentUrl = '$baseUrl$relativeDocumentPath';

        if (responseData['document'] != null) {
          setState(() {
            _convertedFileUrl = fullDocumentUrl;
          });

          print("$_convertedFileUrl");
        } else {
          setState(() {
            _error = "Document conversion failed or returned empty.";
          });
        }
      } else {
        setState(() {
          _error = "Failed to convert the file.";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to download the docx file from url
  Future<void> downloadFile(String url, String fileName) async {
    print("Download initiated.");
    setState(() {
      _isLoading = true;
      _status = "Downloading...";
    });

    try {
      // Step 1: Check and request storage permission
      print("Checking storage permissions...");
      if (!await _requestStoragePermission()) {
        print("Storage permission denied.");
        setState(() => _status = "Storage permission denied.");
        return;
      }
      print("Storage permission granted.");

      // Step 2: Fetch file from the URL
      print("Fetching file from URL: $url");
      final response = await http.get(Uri.parse(url));
      print("HTTP Response Status Code: ${response.statusCode}");
      if (response.statusCode != 200) {
        setState(() => _status = "Failed to download: ${response.statusCode}");
        print("Download failed with status code ${response.statusCode}");
        return;
      }
      print("File fetched successfully from URL.");

      // Step 3: Save file to public Downloads folder
      final filePath = "/storage/emulated/0/Download/$fileName";
      print("Saving file to path: $filePath");
      await File(filePath).writeAsBytes(response.bodyBytes);
      print("File saved successfully to $filePath.");
      setState(() => _status = "File saved to: $filePath");
    } catch (e) {
      print("Error occurred during file download: $e");
      setState(() => _status = "Error: $e");
    } finally {
      print("Download process completed.");
      setState(() => _isLoading = false);
    }
  }

// Method to request storage permission
  Future<bool> _requestStoragePermission() async {
    print("Requesting storage permissions...");
    if (await Permission.storage.isGranted ||
        await Permission.manageExternalStorage.isGranted) {
      print("Storage permission already granted.");
      return true;
    }

    if (await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      print("Storage permission granted after request.");
      return true;
    }

    if (await Permission.storage.isPermanentlyDenied) {
      print("Storage permission permanently denied. Opening app settings...");
      await openAppSettings();
    } else {
      print("Storage permission denied.");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: height * 0.4,
              width: width * 0.7,
              child: Card(
                  elevation: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "PDF to Document Converter",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),

                        SizedBox(
                          height: height * 0.01,
                        ),

                        //upload pdf ##########################################################
                        InkWell(
                          onTap: () {
                            pickFiles();
                          },
                          // splashColor: Color.fromARGB(255, 21, 90, 147),
                          child: SizedBox(
                            height: height * 0.04,
                            width: width * 0.4,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 21, 90, 147),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.file_open_outlined,
                                    color: Colors.blue[900],
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Text(
                                    "UPLOAD PDF",
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),

                        // picked file will shoned here #####################################

                        isfilepicked
                            ? Text(
                                "Selected pdf: ${path.basename(_pdfFile!.path)}",
                                style: TextStyle(
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.w500),
                              )
                            : Container(),

                        SizedBox(
                          height: height * 0.02,
                        ),

                        // for error showing####################################
                        if (_error != null)
                          Text(
                            "$_error",
                            style: TextStyle(color: Colors.red),
                          ),

                        //loading######################################

                        if (_isLoading)
                          SpinKitThreeBounce(
                            color: Colors.black,
                            size: 40.0, // Adjust size as necessary
                          ),

                        //upload convert ##########################################################
                        SizedBox(
                          height: height * 0.06,
                          width: width * 0.5,
                          child: InkWell(
                            onTap: () {
                              _convertFile();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 26, 89, 205),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Text(
                                "CONVERT TO DOCX",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),

                        //download button fo the loac storges ###########################################################################3
                        if (_convertedFileUrl != null)
                          Column(
                            children: [
                              SizedBox(
                                height: height * 0.06,
                                width: width * 0.4,
                                child: InkWell(
                                  onTap: () {
                                    downloadFile("$_convertedFileUrl",
                                        "${path.basename(_pdfFile!.path)}${DateTime.now().microsecondsSinceEpoch}.docx");

                                    print("Document URL: $_convertedFileUrl");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("$_status")));
                                  },
                                  child: Card(
                                    color: Colors.amber,
                                    child: Center(
                                        child: Text(
                                            "Download Converted Document")),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
