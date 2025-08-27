import 'package:flutter/material.dart';
import 'package:khonobuzz/auth_screens.dart'; // Import BlinkingImage

// This is the new dashboard screen for the app.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/back-2.png', // This image should be the full screen background.
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // Removed SafeArea to allow content to extend to full screen.
        Scaffold(
          backgroundColor: Colors.transparent, // Make scaffold background transparent to show the Stack image
          body: Column(
            children: [
              // Top App Bar/Header section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Khonology logo
                    Image.asset(
                      'assets/images/logo.png',
                      width: 180, // Increased from 150
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end, // Align icons to the end of the expanded space
                        children: const [
                          // Dropdown arrow icon
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(width: 15),
                          // User profile icon
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Dashboard title with icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    // Dashboard icon (rocket icon from your provided image)
                    Image.asset(
                      'assets/images/Group_32151.png',
                      width: 40, // Increased from 30
                      height: 40, // Increased from 30
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: const Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main content area of the dashboard
              const Expanded(
                child: Center(
                  child: Text(
                    'Dashboard Content Goes Here',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              
              // Footer with copyright information
              // Removed copyright information as per user request.
            ],
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
    );
  }
}
