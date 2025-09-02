import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this package for SystemChrome
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import cloud_firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import firebase_auth
import 'package:khonobuzz/firebase_options.dart'; // Import the new firebase_options.dart
import 'package:khonobuzz/auth_screens.dart'; // Import the new auth_screens.dart
import 'package:khonobuzz/landing_screen.dart'; // Import the LandingScreen
import 'package:flutter/rendering.dart'; // Import for debugPaintSizeEnabled
import 'package:khonobuzz/routes.dart'; // Import the new routes.dart
import 'package:khonobuzz/dashboard_screen.dart'; // Import the dashboard_screen
import 'package:khonobuzz/base_screen.dart';
import 'package:khonobuzz/resource_allocation_screen.dart';
import 'package:khonobuzz/time_allocation_screen.dart';
import 'package:khonobuzz/project_data_screen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  // Ensure that Flutter's widgets are initialized before the SystemChrome call
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: username, // Assuming username is used as email for authentication
        password: password,
      );
      // Save additional user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': username,
        'createdAt': Timestamp.now(),
      });
      return 'Registration successful';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else {
        throw Exception('Firebase Auth Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  Future<String> login(String username, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username, // Assuming username is used as email for authentication
        password: password,
      );
      return 'Login successful';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception('Firebase Auth Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to log in: $e');
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

  Future<void> _register(BuildContext screenContext) async {
    try {
      final message = await _authService.register(
        _registerUsernameController.text,
        _registerPasswordController.text,
      );
      if (!mounted) return;
      _showSnackBar(message);
      _registerUsernameController.clear();
      _registerPasswordController.clear();
      if (!screenContext.mounted) return; // Add this specific check for screenContext
      Navigator.pushReplacementNamed(screenContext, '/login');
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    }
  }

  Future<void> _login(BuildContext screenContext) async {
    try {
      final message = await _authService.login(
        _loginUsernameController.text,
        _loginPasswordController.text,
      );
      if (!mounted) return;
      _showSnackBar(message);
      if (!screenContext.mounted) return;
      // Navigate directly to DashboardScreen instead of using named route to bypass potential route registration issues.
      Navigator.pushReplacement(
        screenContext,
        MaterialPageRoute(
          builder: (context) => BaseScreen(
            selectedDrawerItem: 'Dashboard',
            body: DashboardScreen(),
            onLogout: _createLogoutCallback(),
          ),
        ),
      );
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    }
  }

  // This now returns a function that accepts BuildContext
  void Function(BuildContext) _createLogoutCallback() {
    return (BuildContext context) => _logout(context);
  }

  void _logout(BuildContext context) {
    _loginUsernameController.clear();
    _loginPasswordController.clear();
    _registerUsernameController.clear();
    _registerPasswordController.clear();
    Navigator.pushReplacementNamed(context, '/login');
    _showSnackBar('Logged out successfully');
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
              onLoginPressed: (screenContext) => _login(screenContext), // Pass LoginScreen's context
              onRegisterPressed: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
            ),
        '/register': (context) => RegisterScreen(
              usernameController: _registerUsernameController,
              passwordController: _registerPasswordController,
              onRegisterPressed: (screenContext) => _register(screenContext), // Pass RegisterScreen's context
              onLoginPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
        AppRoutes.resourceAllocation: (context) => BaseScreen(
              selectedDrawerItem: 'Resource Allocation',
              body: ResourceAllocationScreen(),
              onLogout: _createLogoutCallback(), // No longer pass context here
            ),
        AppRoutes.timeKeeping: (context) => BaseScreen(
              selectedDrawerItem: 'Time Keeping',
              body: TimeAllocationScreen(),
              onLogout: _createLogoutCallback(), // No longer pass context here
            ),
        AppRoutes.projectData: (context) => BaseScreen(
              selectedDrawerItem: 'Project Data',
              body: ProjectDataScreen(),
              onLogout: _createLogoutCallback(), // No longer pass context here
            ),
      },
    );
  }
}
