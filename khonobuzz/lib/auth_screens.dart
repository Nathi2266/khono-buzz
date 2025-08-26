import 'package:flutter/material.dart';
import 'package:khonobuzz/main.dart'; // Import main.dart for AuthService and controllers
import 'dart:async'; // Added this import

// A custom reusable widget for the styled TextField.
class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // This container is used to create the outer rounded box and shadow.
      decoration: BoxDecoration(
        color: Colors.transparent, // Transparent background for the container
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
        boxShadow: [
          // This creates the subtle shadow effect
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5), // Changes position of shadow
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white), // Text color is white
        decoration: InputDecoration(
          // This decoration creates the thin, rounded border.
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54), // Hint text is a lighter white
          filled: true,
          fillColor: Colors.transparent, // Changed to transparent
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none, // No side border for a cleaner look
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Color(0xFFe91e63), // The pinkish border color
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Color(0xFFe91e63), // The pinkish border color on focus
              width: 2.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15.0,
          ),
        ),
      ),
    );
  }
}

// A custom reusable widget for a blinking image.
class BlinkingImage extends StatefulWidget {
  final String imagePath;

  const BlinkingImage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  _BlinkingImageState createState() => _BlinkingImageState();
}

class _BlinkingImageState extends State<BlinkingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _blinkCount = 0;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Duration for one fade (e.g., fade out or fade in)
    );

    // Animation from opaque (1.0) to transparent (0.0)
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        // Animation completed (image faded out), now reverse to fade in
        _controller.reverse();
      } else if (_controller.status == AnimationStatus.dismissed) {
        // Animation dismissed (image faded in)
        _blinkCount++;
        if (_blinkCount < 2) {
          // If less than two blinks completed, start fading out again for the next blink
          _controller.forward();
        } else {
          // Two blinks completed, reset count and start the 5-second delay
          _blinkCount = 0;
          _startDelayTimer();
        }
      }
    });

    // Start the initial 5-second delay
    _startDelayTimer();
  }

  void _startDelayTimer() {
    // Ensure the controller is reset to its initial state (fully opaque) before delay
    // The animation is from 1.0 to 0.0, so controller.value = 0.0 corresponds to opaque.
    _controller.value = 0.0;
    _delayTimer?.cancel();
    _delayTimer = Timer(const Duration(seconds: 8), () { // Changed from 8 seconds to 7 seconds
      // After 7 seconds, start the first fade out for the blinking effect
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Image.asset(widget.imagePath),
        );
      },
    );
  }
}

// This is the main widget for your login screen.
class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final VoidCallback onRegisterPressed;

  const LoginScreen({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.onLoginPressed,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Reverted to transparent for background image
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroud.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Custom text field for "Email Address"
                  CustomTextField(
                    hintText: 'Email Address',
                    controller: usernameController,
                  ),
                  const SizedBox(height: 20),
                  // Custom text field for "Password"
                  CustomTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  // The Confirm button
                  ElevatedButton(
                    onPressed: onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe91e63), // A subtle red color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 15.0,
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'CONFIRM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: onRegisterPressed,
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlinkingImage(
              imagePath: 'assets/images/discs.png',
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onRegisterPressed;
  final VoidCallback onLoginPressed;

  const RegisterScreen({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.onRegisterPressed,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Reverted to transparent for background image
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroud.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Custom text field for "Email Address"
                  CustomTextField(
                    hintText: 'Email Address',
                    controller: usernameController,
                  ),
                  const SizedBox(height: 20),
                  // Custom text field for "Password"
                  CustomTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  // The Confirm button
                  ElevatedButton(
                    onPressed: onRegisterPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe91e63), // A subtle red color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 15.0,
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: onLoginPressed,
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlinkingImage(
              imagePath: 'assets/images/discs.png',
            ),
          ),
        ],
      ),
    );
  }
}
