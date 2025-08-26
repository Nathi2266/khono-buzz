import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/backgroud.png',
            fit: BoxFit.cover,
          ),
        ),
        // Content on top of the background
        child,
      ],
    );
  }
}
