import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAuthScreen extends StatefulWidget {
  @override
  _GoogleAuthScreenState createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/drive'],
  );

  bool _isLoading = false;

  // Step 1: Authenticate with Google
  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Initiate Google Sign-In
      GoogleSignInAccount? user = await _googleSignIn.signIn();

      if (user == null) {
        // User cancelled the sign-in process
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Step 2: Get Authorization Code
      final GoogleSignInAuthentication auth = await user.authentication;
      final String authCode =
          auth.serverAuthCode ?? ''; // Use null-coalescing if null

      if (authCode.isEmpty) {
        // If authCode is null or empty, show an error
        print('Error: Authorization code is empty');
        return;
      }

      // Step 3: Send the authorization code to the backend for token exchange
      final response = await http.post(
        Uri.parse('https://ocr.goodwish.com.np/api/auth/google/callback/'),
        body: json.encode({'code': authCode}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Step 4: Handle the backend response
        final data = json.decode(response.body);
        final String token = data['token'];
        final String photo = data['photo'];
        final String name = data['name'];
        final String email = data['email'];

        // Save the token and other details in local storage (e.g., SharedPreferences or Secure Storage)
        // For now, let's just print the values
        print('Token: $token');
        print('Name: $name');
        print('Email: $email');
        print('Photo URL: $photo');

        // You can now navigate to your home screen or another route
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle error from backend
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Step 5: Sign Out
  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    print('User signed out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google OAuth Sign In')),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _handleGoogleSignIn,
                    child: Text('Sign In with Google'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _handleSignOut,
                    child: Text('Sign Out'),
                  ),
                ],
              ),
      ),
    );
  }
}
