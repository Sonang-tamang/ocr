// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PdfToDoc extends StatefulWidget {
  const PdfToDoc({super.key});

  @override
  State<PdfToDoc> createState() => _PdfToDocState();
}

class _PdfToDocState extends State<PdfToDoc> {
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
                            "PDF to Document Converter",
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
                              "CONVERT TO DOX",
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
