// ignore_for_file: unused_import, deprecated_member_use, use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:khonobuzz/main.dart'; // Import main.dart for AuthService and controllers
import 'dart:async'; // Added this import
import 'package:khonobuzz/landing_screen.dart'; // Import the LandingScreen to reference in comments

class AnimatedCatchphrase extends StatefulWidget {
  const AnimatedCatchphrase({Key? key}) : super(key: key);

  @override
  _AnimatedCatchphraseState createState() => _AnimatedCatchphraseState();
}

class _AnimatedCatchphraseState extends State<AnimatedCatchphrase> with SingleTickerProviderStateMixin {
  final List<String> phrases = [
    "Buzzing with innovation.",
    "The pulse of the tech community.",
    "Your digital tribe.",
    "Connect. Collaborate. Create.",
    "Ignite your cloud journey.",
    "Where tech talks happen.",
    "Find your tech synergy.",
    "Get on the Khonobuzz.",
    "Building the future, one connection at a time.",
    "Your network, accelerated.",
    "Plug into the cloud.",
    "Delivering digital connections.",
    "Shaping tomorrow, together.",
    "The hub for tech visionaries.",
    "Connecting data, people, and ideas.",
    "Drive digital transformation in your network.",
    "Where innovation finds its home.",
    "Level up your network.",
    "The official tech community app.",
    "Connect with purpose.",
  ];

  late int _currentIndex;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // fade duration
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    // Cycle phrases every 3.5 seconds including fade transition
    Future.delayed(const Duration(milliseconds: 3500), _nextPhrase);
  }

  void _nextPhrase() {
    _controller.reverse().then((_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % phrases.length;
      });
      _controller.forward();
      Future.delayed(const Duration(milliseconds: 3500), _nextPhrase);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        phrases[_currentIndex],
        textAlign: TextAlign.center,
        maxLines: 1, // Ensure single line
        overflow: TextOverflow.ellipsis, // Truncate overflow with ellipsis
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto', // or your preferred font
        ),
      ),
    );
  }
}

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
   createState() => _BlinkingImageState();
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
    _delayTimer = Timer(const Duration(seconds: 7), () { // Corrected from 8 seconds back to 7 seconds
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

// A custom reusable widget for a flowing button.
class FlowingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color startColor;
  final Color endColor;
  final Duration animationDuration;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final ButtonType buttonType; // New parameter to differentiate button types

  const FlowingButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.startColor = const Color(0xFFe91e63),
    this.endColor = const Color(0xFFc2185b),
    this.animationDuration = const Duration(milliseconds: 300),
    this.padding,
    this.shape,
    this.buttonType = ButtonType.elevated, // Default to elevated button
  }) : super(key: key);

  @override
  _FlowingButtonState createState() => _FlowingButtonState();
}

enum ButtonType {
  elevated,
  text,
}

class _FlowingButtonState extends State<FlowingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = ColorTween(
      begin: widget.startColor,
      end: widget.endColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          if (widget.buttonType == ButtonType.elevated) {
            return ElevatedButton(
              onPressed: () => widget.onPressed(), // Correctly pass the onPressed callback
              style: ElevatedButton.styleFrom(
                backgroundColor: _animation.value, // Use animated color
                shape: widget.shape ?? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: widget.padding ?? const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 15.0,
                ),
                elevation: 5,
              ),
              child: widget.child,
            );
          } else {
            return TextButton(
              onPressed: () => widget.onPressed(), // Correctly pass the onPressed callback
              style: TextButton.styleFrom(
                foregroundColor: _animation.value, // Use animated color for text
                padding: widget.padding,
              ),
              child: widget.child,
            );
          }
        },
      ),
    );
  }
}

// This is the main widget for your login screen.
class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final void Function(BuildContext context) onLoginPressed;
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
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30), // Increased size
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen (LandingScreen)
              },
            ),
          ),
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
                mainAxisSize: MainAxisSize.min, // Changed from MainAxisAlignment.center to min for better control
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png', // Updated logo path here
                    height: 60,
                  ),
                  const SizedBox(height: 20),
                  const AnimatedCatchphrase(), // Inserted here
                  const SizedBox(height: 40), // Space between catchphrase and text fields
                  CustomTextField(
                    hintText: 'Email Address',
                    controller: usernameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  FlowingButton(
                    onPressed: () => onLoginPressed(context),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70.0, // Adjusted padding
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    startColor: const Color(0xFFe91e63),
                    endColor: const Color(0xFFc2185b),
                    child: const Text(
                      'CONFIRM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FlowingButton(
                    onPressed: onRegisterPressed,
                    buttonType: ButtonType.text,
                    startColor: Colors.white70,
                    endColor: Colors.white,
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: Colors.white70), // Keep the original text style
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
  final void Function(BuildContext context) onRegisterPressed;
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
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30), // Increased size
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen (LandingScreen)
              },
            ),
          ),
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
                  FlowingButton(
                    onPressed: () => onRegisterPressed(context),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70.0, // Adjusted padding
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    startColor: const Color(0xFFe91e63),
                    endColor: const Color(0xFFc2185b),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FlowingButton(
                    onPressed: onLoginPressed,
                    buttonType: ButtonType.text,
                    startColor: Colors.white70,
                    endColor: Colors.white,
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.white70), // Keep the original text style
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

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Your static background here
        Positioned.fill(
          child: Image.asset(
            'assets/images/your_static_background.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40), // adjust spacing as needed
              Center(
                child: Image.asset(
                  'assets/images/khonology_logo_red.png',
                  height: 60, // adjust size as per design
                ),
              ),
              const SizedBox(height: 20), // space between logo and catchphrase
              const AnimatedCatchphrase(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Login button action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('LOGIN'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Register button action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('REGISTER'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40), // bottom padding
            ],
          ),
        ),
      ],
    ),
  );
}
