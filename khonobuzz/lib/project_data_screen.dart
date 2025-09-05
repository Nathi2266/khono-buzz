import 'package:flutter/material.dart';
// import 'package:khonobuzz/base_screen.dart'; // No longer needed here

class ProjectDataScreen extends StatelessWidget {
  const ProjectDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This screen should only return its body content, not a full BaseScreen
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
              'Project Data Content Goes Here',
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
