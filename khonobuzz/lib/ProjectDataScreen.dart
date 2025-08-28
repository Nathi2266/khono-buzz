import 'package:flutter/material.dart';
// import 'package:khonobuzz/auth_screens.dart'; // No longer needed directly here
import 'package:khonobuzz/base_screen.dart'; // Import the new BaseScreen

class ProjectDataScreen extends StatelessWidget {
  const ProjectDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      titleText: 'Project Data',
      body: Center(
        child: const Text(
          'Project Data Content Goes Here',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
