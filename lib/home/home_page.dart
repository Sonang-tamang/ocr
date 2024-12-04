// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ocr/authentication/authentication.dart';
import 'package:ocr/authentication/login_data.dart';
import 'package:ocr/home/welcome.dart';
import 'package:ocr/pages/image_to_doc.dart';
import 'package:ocr/pages/image_to_text.dart';
import 'package:ocr/pages/pdf_to_doc.dart';
import 'package:ocr/pages/pdf_to_image.dart';
import 'package:ocr/pages/table_Extraction.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // geting photos #######################################

  final List<Widget> _pages = [
    Welcome(), // Placeholder for the Home Page content
    PdfToDoc(),
    PdfToImage(),
    ImageToDoc(),
    TableExtension(),
    ImageToText(),
  ];

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index; // Update the selected index when tapped
    });
  }

  void _showPopup(String tabName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$tabName "),
          content: Text("Are you sure you want to $tabName."),
          actions: <Widget>[
            TextButton(
              child: Text("LOGOUT"),
              onPressed: () {
                logoutUser(context);
              },
            ),
          ],
        );
      },
    );
  }

  void logoutUser(BuildContext context) async {
    final box = Hive.box<LoginData>('loginDataBOX');

    // Remove the currentUser data
    await box.delete('currentUser');

    // Navigate to the authentication screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Authentication()),
      (route) => false, // Clear all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the current user data from Hive
    final box = Hive.box<LoginData>('loginDataBOX');
    final currentUser = box.get('currentUser');

    // Check if user data is available
    if (currentUser == null) {
      return const Center(
        child: Text("No user logged in."),
      );
    }

    // Define your base URL
    const String baseUrl = 'https://ocr.goodwish.com.np';

    // Construct the full photo URL
    final String photoUrl = '$baseUrl${currentUser.photo}';

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
                  InkWell(
                    onTap: () {
                      _showPopup("Logout");
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(photoUrl),
                      onBackgroundImageError: (_, __) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Text(" ${currentUser.firstName} ${currentUser.lastName}"),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(),
        body: _pages[_selectedIndex], // Display the current selected page here

        // navigation#################################
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(
                icon: Icon(Iconsax.document), label: "PDF - DOC"),
            NavigationDestination(
                icon: Icon(Iconsax.image), label: "PDF - image"),
            NavigationDestination(
                icon: Icon(Iconsax.document_text), label: "image - DOC"),
            NavigationDestination(
                icon: Icon(Iconsax.box), label: "Table extraction"),
            NavigationDestination(icon: Icon(Iconsax.text), label: "OCR"),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        ));
  }
}
