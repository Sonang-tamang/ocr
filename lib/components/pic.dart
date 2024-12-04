import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ocr/authentication/login_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
        title: const Text("User Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display user photo if available
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(photoUrl),
              onBackgroundImageError: (_, __) => const Icon(Icons.error),
            ),
            const SizedBox(height: 20),
            Text("Name: ${currentUser.firstName} ${currentUser.lastName}"),
            Text("Email: ${currentUser.email}"),
          ],
        ),
      ),
    );
  }
}
