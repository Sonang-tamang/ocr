// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ImageToText extends StatefulWidget {
  const ImageToText({Key? key}) : super(key: key);

  @override
  State<ImageToText> createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> {
  final TextEditingController _controller = TextEditingController();
  final String token =
      '84226ca0b3a35babba70122c7a4baec327400c38'; // Replace with your token

  File? _selectedImage;
  bool _isFilePicked = false;
  bool _isLoading = false;
  bool _isTextExtracted = false;
  String? _errorMessage;
  List<String>? _extractedTextLines;

  /// Picks an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isFilePicked = true;
        _isTextExtracted = false; // Reset the text extraction state
        _extractedTextLines = null;
        _errorMessage = null;
      });
    } else {
      print("No image selected");
      // No image was selected, handle the case as needed
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No image selected")));
    }
  }

  /// Converts the selected image to text using an API
  Future<void> _convertToText() async {
    if (_selectedImage == null) {
      setState(() => _errorMessage = "Please upload an image file to convert.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _extractedTextLines = null;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://ocr.goodwish.com.np/api/image-to-text/'),
      );

      request.headers['Authorization'] = 'Token $token';
      request.files.add(
        await http.MultipartFile.fromPath('image', _selectedImage!.path),
      );

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);

        // Extract lines from the response
        final extractedTextData = jsonData['extracted_text'][0];
        final List<dynamic> lines = extractedTextData['lines'];
        final List<dynamic> paragraphs = extractedTextData['paragraphs'];

        setState(() {
          _extractedTextLines =
              lines.map((line) => line['text'] as String).toList();
          _isTextExtracted = true;

          // Optionally include paragraphs or other structures if needed
          if (paragraphs.isNotEmpty) {
            _extractedTextLines!.add("\n------ Paragraphs ------");
            _extractedTextLines!
                .addAll(paragraphs.map((p) => p['text'] as String));
          }
        });
      } else {
        final responseBody = await response.stream.bytesToString();

        print(
            "Failed to process image. Status: ${response.statusCode}, Error: $responseBody");
        setState(() => _errorMessage =
            "Failed to process image. Status: ${response.statusCode}, Error: $responseBody");
      }
    } catch (e) {
      setState(() => _errorMessage = "An error occurred: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            // for limiton the to the deful size ####################################################
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: height * 0.4,
                minWidth: width * 0.8,
                maxWidth: width * 0.8,
              ),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Image to Text Converter",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.02),

                      // Upload Image Button
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
                                  Icons.image_outlined,
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

                      // Display Selected Image
                      if (_isFilePicked)
                        Text(
                          "Selected Image: ${path.basename(_selectedImage!.path)}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      SizedBox(height: height * 0.02),

                      // Convert Button
                      SizedBox(
                        height: height * 0.06,
                        width: width * 0.5,
                        child: InkWell(
                          onTap: () {
                            _convertToText();

                            print("$_extractedTextLines");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 26, 89, 205),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: Text(
                              "CONVERT TO TEXT",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),

                      // Loading Indicator
                      if (_isLoading) SpinKitDualRing(color: Colors.black),

                      // Display Error Message
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),

                      // Display Extracted Text
                      if (_isTextExtracted && _extractedTextLines != null)
                        if (_isTextExtracted)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Extracted Text:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: height * 0.02),
                              SelectableText(
                                _extractedTextLines!.join('\n'),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
