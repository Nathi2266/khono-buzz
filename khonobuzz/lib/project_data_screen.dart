import 'package:flutter/material.dart';
// import 'package:khonobuzz/base_screen.dart'; // No longer needed here

class ProjectDataScreen extends StatelessWidget {
  const ProjectDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This screen should only return its body content, not a full BaseScreen
    return const Center(
      child: Text(
        'Project Data Content Goes Here',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 18,
        ),
      ),
    );
  }
}
