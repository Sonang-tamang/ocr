// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ocr/authentication/authentication.dart';
import 'package:permission_handler/permission_handler.dart';

class Signupform extends StatefulWidget {
  const Signupform({super.key});

  @override
  State<Signupform> createState() => _Signupform2State();
}

class _Signupform2State extends State<Signupform> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  File? _selectedImage;
//image picker

  Future<void> _pickImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null) {
      // Image was picked successfully, proceed with setting the image
      setState(() {
        _selectedImage = File(returnedImage.path);
      });
    } else {
      // No image was selected, handle the case as needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected")),
      );
    }
  }

  // Function to handle user registration
  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    // Prepare form data
    Map<String, String> formData = {
      "username": usernameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "contact": contactController.text,
    };

    // Create multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://ocr.goodwish.com.np/api/users/"),
    );

    // Add form fields to request
    formData.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add the profile picture if selected
    if (_selectedImage != null) {
      var file = await http.MultipartFile.fromPath(
        'photo',
        _selectedImage!.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(file);
    }

    // Send the request
    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      // Log the raw response
      print("Response Data: $responseData");

      // Check if the response is in HTML (i.e., error page)
      if (response.headers['content-type']?.contains('text/html') == true) {
        // Handle HTML error page
        print("HTML Response: $responseData");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("HTML Error: Please check your request or server.")),
        );
      } else {
        // Attempt to parse JSON response
        try {
          if (response.statusCode == 200 || response.statusCode == 201) {
            var responseJson = json.decode(responseData);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Successful!")),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Authentication()),
            );
          } else {
            var responseJson = json.decode(responseData);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${responseJson['message']}")),
            );
          }
        } catch (e) {
          print("Error decoding JSON: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: Unable to parse server response.")),
          );
        }
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.07,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Container(
                  height: height * 1.1,
                  width: width * .7,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 2, // How much the shadow spreads
                          blurRadius: 10, // How blurry the shadow is
                          offset: Offset(0, 5),
                        ),

                        // welcome text #######################
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          "Welcome to The OCR",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: height * 0.03,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(
                          height: height * 0.04,
                        ),

                        // profile pic slection ############################################

                        Container(
                          width: width,
                          height: height * 0.09,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent.withOpacity(0.5),
                            image: _selectedImage != null
                                ? DecorationImage(
                                    image: FileImage(_selectedImage!),
                                    fit: BoxFit.fill,
                                  )
                                : null,
                          ),
                          child: InkWell(
                            onTap:
                                _pickImage, // Call the image picker function on tap
                            child: _selectedImage == null
                                ? Icon(
                                    Icons.person,
                                    size: height * 0.07,
                                    color: Colors.white,
                                  )
                                : null, // No icon if the user has selected an image
                          ),
                        ),

                        // _selectedImage! = null ? Image.file(_selectedImage!): Text("hello")

                        Text(
                          "Upload you profile picture",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: height * 0.02,
                          ),
                        ),

                        // user data ###########################################

                        SizedBox(
                          height: height * 0.04,
                        ),

                        // text box for username ###############################################
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: const Color.fromARGB(255, 157, 165, 165),
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 96, 93, 93)),
                              ),
                              hintText: "Username*",
                              hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),

                        // text box for Email ###############################################
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: const Color.fromARGB(255, 157, 165, 165),
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 96, 93, 93)),
                              ),
                              hintText: "Email*",
                              hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),

                        // text box for password ###############################################
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: const Color.fromARGB(255, 157, 165, 165),
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 96, 93, 93)),
                              ),
                              hintText: "Password*",
                              hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),

                        // text box for confirm password ###############################################
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: const Color.fromARGB(255, 157, 165, 165),
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 96, 93, 93)),
                              ),
                              hintText: "Confirm Password*",
                              hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),

                        // text box for first name ###############################################
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: const Color.fromARGB(255, 157, 165, 165),
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 96, 93, 93)),
                              ),
                              hintText: "First Name*",
                              hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),

                        // text box for Last name ###############################################
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: const Color.fromARGB(255, 157, 165, 165),
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 96, 93, 93)),
                              ),
                              hintText: "Last Name*",
                              hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),

                        // text box for Contact ###############################################
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: contactController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: const Color.fromARGB(255, 157, 165, 165),
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 96, 93, 93)),
                              ),
                              hintText: "Contact*",
                              hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: height * 0.03,
                        ),

                        // login buttom ##################################

                        SizedBox(
                          height: height * 0.05,
                          width: width * 0.6,
                          child: InkWell(
                            onTap: registerUser,
                            child: Card(
                              color: const Color.fromARGB(255, 55, 135, 200),
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // signup text ########################################################

                        TextButton(
                            onPressed: () {
                              goto_Login();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: Text(
                              "Already have an account? Login ",
                              style: TextStyle(color: Colors.red),
                            )),

                        SizedBox(
                          height: height * 0.05,
                        ),

                        // google login ###############################

                        SizedBox(
                          height: height * 0.06,
                          width: width * 0.5,
                          child: Card(
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Continue with Google ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.018,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.g_mobiledata,
                                  size: height * 0.04,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void goto_Login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authentication()),
    );
  }
}
