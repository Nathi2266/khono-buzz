import 'package:flutter/material.dart';
// import 'package:khonobuzz/base_screen.dart'; // No longer needed here

class TimeAllocationScreen extends StatelessWidget {
  const TimeAllocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Niice_Wrld_A_dark,_abstract_background_with_a_black_background_and_a_red_lin_ce144728-8a69-4c91-9aa3-069deb283a9c.png',
              fit: BoxFit.cover,
            ),
          ),
          const Center(
            child: Text(
              'Time Allocation Content Goes Here',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
