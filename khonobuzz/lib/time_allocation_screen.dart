import 'package:flutter/material.dart';
// import 'package:khonobuzz/base_screen.dart'; // No longer needed here

class TimeAllocationScreen extends StatelessWidget {
  const TimeAllocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This screen should only return its body content, not a full BaseScreen
    return const Center(
      child: Text(
        'Time Allocation Content Goes Here',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 18,
        ),
      ),
    );
  }
}
