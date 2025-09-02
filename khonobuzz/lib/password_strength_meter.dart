import 'package:flutter/material.dart';

class PasswordStrengthMeter extends StatefulWidget {
  final String password;

  const PasswordStrengthMeter({super.key, required this.password});

  @override
  PasswordStrengthMeterState createState() => PasswordStrengthMeterState();
}

class PasswordStrengthMeterState extends State<PasswordStrengthMeter> {
  double _strength = 0.0;
  Color _color = Colors.grey;
  String _feedback = '';

  @override
  void didUpdateWidget(covariant PasswordStrengthMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.password != oldWidget.password) {
      _checkPasswordStrength(widget.password);
    }
  }

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _strength = 0.0;
        _color = Colors.grey;
        _feedback = '';
      });
      return;
    }

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) score++;

    setState(() {
      _strength = score / 5.0;
      if (score <= 1) {
        _color = Colors.red;
        _feedback = 'Very Weak';
      } else if (score == 2) {
        _color = Colors.orange;
        _feedback = 'Weak';
      } else if (score == 3) {
        _color = Colors.yellow;
        _feedback = 'Moderate';
      } else if (score == 4) {
        _color = Colors.lightGreen;
        _feedback = 'Strong';
      } else if (score == 5) {
        _color = Colors.green;
        _feedback = 'Very Strong';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: _strength,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(_color),
        ),
        const SizedBox(height: 5),
        Text(
          _feedback,
          style: TextStyle(color: _color, fontSize: 12),
        ),
      ],
    );
  }
}
