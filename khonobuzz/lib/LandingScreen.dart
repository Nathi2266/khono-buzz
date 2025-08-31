import 'package:flutter/material.dart';
import 'package:khonobuzz/auth_screens.dart'; // Corrected import for BlinkingImage

// This is the main screen for your app's landing page.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We wrap the screen in a SafeArea to avoid UI elements from
    // going behind the device's notch and other overlays.
    return Scaffold(
      // The dark background color for the screen.
      backgroundColor: Colors.transparent, // Reverted to transparent for background image
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroud.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Display the logo from your assets.
                  // Make sure you've added the asset to your pubspec.yaml file.
                  Image.asset(
                    'assets/images/logo.png', // Corrected image path
                    width: 280, // Increased width
                  ),
                  const SizedBox(height: 50),
                  
                  // Button for "Login with Microsoft".
                  // This will be replaced with "LOGIN" and "REGISTER" as requested.
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe91e63), // A dark red color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70.0,
                        vertical: 15.0,
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Button for "Register".
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White background for the second button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70.0,
                        vertical: 15.0,
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlinkingImage(
              imagePath: 'assets/images/discs.png',
            ),
          ),
        ],
      ),
    );
  }
}

// To use this screen, you would set it as the home for your app.
// For example:
// void main() {
//   runApp(const MaterialApp(
//     home: LandingScreen(),
//   ));
// }
