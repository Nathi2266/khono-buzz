import 'package:flutter/material.dart';
// import 'package:khonobuzz/auth_screens.dart'; // No longer needed directly here
import 'package:khonobuzz/base_screen.dart'; // Import the new BaseScreen

// This is the new dashboard screen for the app.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      titleText: 'Dashboard',
      body: Center(
        child: const Text(
          'Dashboard Content Goes Here',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
