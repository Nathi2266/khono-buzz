import 'package:flutter/material.dart';
// import 'package:khonobuzz/auth_screens.dart'; // No longer needed directly here
import 'package:khonobuzz/base_screen.dart'; // Import the new BaseScreen

class TimeAllocationScreen extends StatelessWidget {
  const TimeAllocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      titleText: 'Time Keeping',
      body: Center(
        child: const Text(
          'Time Allocation Content Goes Here',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
