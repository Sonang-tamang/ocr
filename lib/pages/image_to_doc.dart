// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ocr/home/welcome.dart';

import 'pdf_to_doc.dart';
import 'pdf_to_image.dart';

class ImageToDoc extends StatefulWidget {
  const ImageToDoc({super.key});

  @override
  State<ImageToDoc> createState() => _ImageToDocState();
}

class _ImageToDocState extends State<ImageToDoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 150,
              width: 350,
              child: Card(
                  elevation: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Image tp Document Converter",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),

                        //upload pdf ##########################################################
                        InkWell(
                          onTap: () {},
                          // splashColor: Color.fromARGB(255, 21, 90, 147),
                          child: SizedBox(
                            height: 30,
                            width: 280,
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
                                    width: 10,
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
                          height: 20,
                        ),

                        //upload convert ##########################################################
                        SizedBox(
                          height: 30,
                          width: 280,
                          child: Container(
                            color: const Color.fromARGB(255, 26, 89, 205),
                            child: Center(
                                child: Text(
                              "CONVERT TO IMAGES",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
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
