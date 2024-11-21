// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ocr/authentication/signUpForm.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
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
                                  fontSize: 15,
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
