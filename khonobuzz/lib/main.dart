import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this package for SystemChrome
import 'package:http/http.dart' as http;
import 'package:khonobuzz/auth_screens.dart'; // Import the new auth_screens.dart
import 'dart:convert';
import 'package:khonobuzz/LandingScreen.dart'; // Import the LandingScreen
import 'package:flutter/rendering.dart'; // Import for debugPaintSizeEnabled
import 'package:khonobuzz/DashboardScreen.dart'; // Import the DashboardScreen

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  // Ensure that Flutter's widgets are initialized before the SystemChrome call
  WidgetsFlutterBinding.ensureInitialized();
  
  // This line makes the app draw full-screen, extending behind system UI overlays.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Make status bar transparent
    systemNavigationBarColor: Colors.transparent, // Make navigation bar transparent
    systemNavigationBarIconBrightness: Brightness.light, // For dark navigation icons
    statusBarIconBrightness: Brightness.light, // For dark status bar icons
  ));

  // Disable debug paint size boxes for a cleaner debug view
  debugPaintSizeEnabled = false;

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
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    try {
      final message = await _authService.register(
        _registerUsernameController.text,
        _registerPasswordController.text,
      );
      _showSnackBar(message);
      _registerUsernameController.clear();
      _registerPasswordController.clear();
      _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn); // Navigate to login screen
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    }
  }

  Future<void> _login(BuildContext context) async {
    try {
      final message = await _authService.login(
        _loginUsernameController.text,
        _loginPasswordController.text,
      );
      _showSnackBar(message);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
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
      scaffoldMessengerKey: scaffoldMessengerKey, // Assign the GlobalKey here
      home: const LandingScreen(), // Set LandingScreen as the initial home
      routes: {
        '/login': (context) => LoginScreen(
              usernameController: _loginUsernameController,
              passwordController: _loginPasswordController,
              onLoginPressed: (context) => _login(context),
              onRegisterPressed: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
            ),
        '/register': (context) => RegisterScreen(
              usernameController: _registerUsernameController,
              passwordController: _registerPasswordController,
              onRegisterPressed: (context) => _register(context),
              onLoginPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
      },
    );
  }
}
