import 'package:flutter/material.dart';
import 'package:khonobuzz/base_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      selectedDrawerItem: 'Dashboard',
      body: const Center(
        child: Text(
          'Actual Dashboard Content Goes Here!',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
