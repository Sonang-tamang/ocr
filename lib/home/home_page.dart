// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ocr/home/welcome.dart';
import 'package:ocr/pages/image_to_doc.dart';
import 'package:ocr/pages/pdf_to_doc.dart';
import 'package:ocr/pages/pdf_to_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Welcome(), // Placeholder for the Home Page content
    PdfToDoc(),
    PdfToImage(),
    ImageToDoc()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index when tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 130,
            child: Image.asset("assets/images/logo192.png"),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 195, 188, 188),
        toolbarHeight: 95,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(Icons.person),
                  iconSize: 40,
                ),
                Text(
                  "sign in",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Display the current selected page here
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: const Color.fromARGB(255, 127, 135, 142),
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor:
                const Color.fromARGB(255, 76, 80, 83).withOpacity(0.1),
            color: const Color.fromARGB(255, 71, 69, 69),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.file_present_rounded,
                text: 'PDF to DOC',
              ),
              GButton(
                icon: Icons.file_open_rounded,
                text: 'PDF to image',
              ),
              GButton(
                icon: Icons.image,
                text: 'image to DOC',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
