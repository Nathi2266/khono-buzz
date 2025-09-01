import 'package:flutter/material.dart';
// import 'package:khonobuzz/base_screen.dart'; // No longer needed here

class DashboardScreen extends StatelessWidget {
  final VoidCallback? onLogout;
  const DashboardScreen({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    // This screen should only return its body content, not a full BaseScreen
    return const Center(
      child: Text(
        'Welcome to the Dashboard!',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 18,
        ),
      ),
    );
  }
}
