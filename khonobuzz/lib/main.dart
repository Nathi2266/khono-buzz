import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this package for SystemChrome
import 'package:http/http.dart' as http;
import 'package:khonobuzz/auth_screens.dart'; // Import the new auth_screens.dart
import 'dart:convert';

void main() {
  // Ensure that Flutter's widgets are initialized before the SystemChrome call
  WidgetsFlutterBinding.ensureInitialized();
  
  // This line makes the app full-screen by hiding all system UI overlays
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(const MainApp());
}

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5000'; // For Android Emulator. Use your machine's IP for physical device.

  Future<String> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return 'Registration successful';
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception(responseBody['message'] ?? 'Registration failed');
    }
  }

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return 'Login successful';
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception(responseBody['message'] ?? 'Invalid username or password');
    }
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AuthService _authService = AuthService();
  final PageController _pageController = PageController();

  final TextEditingController _registerUsernameController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _loginUsernameController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _register() async {
    try {
      final message = await _authService.register(
        _registerUsernameController.text,
        _registerPasswordController.text,
      );
      _showSnackBar(message);
      _registerUsernameController.clear();
      _registerPasswordController.clear();
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    }
  }

  Future<void> _login() async {
    try {
      final message = await _authService.login(
        _loginUsernameController.text,
        _loginPasswordController.text,
      );
      _showSnackBar(message);
      // Navigate to another screen or update UI on successful login
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    }
  }

  @override
  void dispose() {
    _registerUsernameController.dispose();
    _registerPasswordController.dispose();
    _loginUsernameController.dispose();
    _loginPasswordController.dispose();
    _pageController.dispose(); // Dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KhonoBuzz',
      debugShowCheckedModeBanner: false, // Remove the debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: [
                RegisterScreen(
                  usernameController: _registerUsernameController,
                  passwordController: _registerPasswordController,
                  onRegisterPressed: _register,
                  onLoginPressed: () {
                    _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                  },
                ),
                LoginScreen(
                  usernameController: _loginUsernameController,
                  passwordController: _loginPasswordController,
                  onLoginPressed: _login,
                  onRegisterPressed: () {
                    _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                  },
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/discs.png',
                fit: BoxFit.fitWidth, // Adjust as needed to match the image
              ),
            ),
          ],
        ),
      ),
    );
  }
}
