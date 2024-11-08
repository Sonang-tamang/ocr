// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class Testhome extends StatefulWidget {
  const Testhome({super.key});

  @override
  State<Testhome> createState() => _TesthomeState();
}

class _TesthomeState extends State<Testhome> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          // title: Text("RAN AI"),
          // centerTitle: true,
          ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: height *
                //       0.09, // for maintening the size of the tezt ##############
                // ),
                Text(
                  "Hello,User",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                Text(
                  "how can i help you roght now?",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //firt big block for chat button #############################################
                      width: width * 0.4,
                      height: height * 0.3,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(60))),

                      child: Column(
                        // inside the mic ##################################################################################
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent.withOpacity(0.5)),
                                child: Icon(
                                  Icons.mic_none_rounded,
                                  size: height * 0.06,
                                  color: Colors.white,
                                )),
                          ),
                          // SizedBox(
                          //   height: height * 0.04,
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Talk\n ",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "With \n",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " RAN",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          // second squre for the chat or talking button ########################
                          width: width * 0.45,
                          height: height * 0.14,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.transparent.withOpacity(0.5)),
                                  child: Icon(
                                    Icons.send_outlined,
                                    size: height * 0.04,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text("Chat with RAN",
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Container(
                          // third and small fo for OCR #################################################
                          width: width * 0.45,
                          height: height * 0.14,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.outline,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(60),
                                  bottomLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.transparent.withOpacity(0.5)),
                                  child: Icon(
                                    Icons.qr_code_scanner_outlined,
                                    size: height * 0.04,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text("Convert your Files",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
