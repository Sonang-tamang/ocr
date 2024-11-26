// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_declarations, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ocr/home/welcome.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import 'pdf_to_doc.dart';
import 'pdf_to_image.dart';

class ImageToDoc extends StatefulWidget {
  const ImageToDoc({super.key});

  @override
  State<ImageToDoc> createState() => _ImageToDocState();
}

class _ImageToDocState extends State<ImageToDoc> {
  File? _selectedImage;
  bool isfilepicked = false;
  bool _isLoading = false;
  String? _convertedFileUrl;
  String? _errorMessage;
  final String _token = '84226ca0b3a35babba70122c7a4baec327400c38'; //token
  String permissionStatus = "Permission not checked yet.";

  String _status = "Ready to download";

// to pick image

  Future<void> _pickImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null) {
      print("hurray");
      // Image was picked successfully, proceed with setting the image
      setState(() {
        _selectedImage = File(returnedImage.path);
        isfilepicked = true;
      });
    } else {
      // No image was selected, handle the case as needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected")),
      );
    }
  }

  // Function to convert image to DOCX
  Future<void> _convertImage() async {
    if (_selectedImage == null) {
      setState(() {
        _errorMessage = "Please upload an image to convert.";
      });
      print(" eee");
      return;
    }

    setState(() {
      _isLoading = true;
      _convertedFileUrl = null;
    });

    try {
      final Uri url = Uri.parse('https://ocr.goodwish.com.np/api/convert-doc/');
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Token $_token'
        ..files.add(
            await http.MultipartFile.fromPath('image', _selectedImage!.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final responseJson = responseData.body;

        print("Response JSON: $responseJson");

        // Now, parse the JSON response and construct the full URL
        final Map<String, dynamic> responseMap = json.decode(responseJson);
        // Get the relative document path
        final String relativeDocumentPath = responseMap['document'];

        print("dami");

        // Construct the full URL by concatenating the base URL with the relative path
        final String baseUrl =
            'https://ocr.goodwish.com.np'; // Ensure this matches your server's base URL
        final String fullDocumentUrl = '$baseUrl$relativeDocumentPath';

        setState(() {
          _convertedFileUrl = fullDocumentUrl; // Set the full document URL
        });
      } else {
        setState(() {
          print("${response.toString()}");
          _errorMessage = "An error occurred while converting the file.";
        });
      }
    } catch (error) {
      setState(() {
        print("bbb");
        _errorMessage = "An error occurred while converting the file.";
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
                            "Image to Document Converter",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),

                        SizedBox(
                          height: height * 0.01,
                        ),

                        //upload pdf ##########################################################
                        InkWell(
                          onTap: () {
                            _pickImage();
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
                                    "UPLOAD IMAGE",
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
                                "Selected Image: ${path.basename(_selectedImage!.path)}",
                                style: TextStyle(
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.w500),
                              )
                            : Container(),

                        SizedBox(
                          height: height * 0.02,
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
                              _convertImage();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 26, 89, 205),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Text(
                                "CONVERT TO IMAGES",
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
                                        "Converted images_${DateTime.now().microsecondsSinceEpoch}.docx");

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
