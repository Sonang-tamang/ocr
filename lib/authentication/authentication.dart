// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations

import 'dart:convert'; // For JSON encoding and decoding
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:ocr/authentication/signUpForm.dart';
import 'package:ocr/home/welcome.dart';
import 'package:ocr/pages/image_to_doc.dart';
import 'package:ocr/pages/pdf_to_doc.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false; // To manage loading state

  // for google sign in flunction  ##################################3

  // SignInWithGoogle() async {
  //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

  //   final GoogleSignInAuthentication gAuth = await gUser!.authentication;

  //   final crendetial = GoogleAU.credetial(gAuth)
  // }

  // Function to handle login
  Future<void> loginUser() async {
    final String apiUrl = "https://ocr.goodwish.com.np/api/login/";
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage("Username and Password cannot be empty");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey("token")) {
          // Login successful
          print("Login successful: $responseData");
          _showMessage(
              "Welcome, ${responseData['first_name']} ${responseData['last_name']}!");

          // Navigate to the Welcome screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PdfToDoc()),
          );
        } else {
          // Handle unexpected response without token
          _showMessage("Login failed: Unexpected response format");
          print("Unexpected response: $responseData");
        }
      } else {
        print("Payload: ${jsonEncode({
              "username": username,
              "password": password
            })}");

        print("$response");
        // Handle non-200 status codes
        _showMessage("Error: ${response.statusCode}");
      }
    } catch (e) {
      _showMessage("An error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to show a message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
            child: Container(
              height: height * .6,
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
                      height: height * 0.07,
                    ),

                    // text box for username ###############################################
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: "username*",
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),

                    // text box for passport ################################
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: "password*",
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
                        onTap: () {
                          loginUser();
                        },
                        child: Card(
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              "LOGIN",
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
                        onPressed: goto_signUp,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: Text(
                          "Don't have an account? Sign Up ",
                          style: TextStyle(color: Colors.red),
                        )),

                    SizedBox(
                      height: height * 0.07,
                    ),

                    // google login ###############################

                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.4,
                      child: Card(
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Continue with Google ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.015,
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
          )
        ],
      ),
    );
  }

  void goto_signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Signupform()),
    );
  }
}
