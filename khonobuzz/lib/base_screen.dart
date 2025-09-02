import 'package:flutter/material.dart';
import 'package:khonobuzz/auth_screens.dart'; // For BlinkingImage widget
import 'package:khonobuzz/dashboard_screen.dart';
import 'package:khonobuzz/resource_allocation_screen.dart';
import 'package:khonobuzz/time_allocation_screen.dart';
import 'package:khonobuzz/project_data_screen.dart';
import 'package:khonobuzz/profile_screen.dart';

class BaseScreen extends StatefulWidget {
  final String selectedDrawerItem;
  final Widget? body;
  final void Function(BuildContext context)? onLogout; // Changed to accept BuildContext

  const BaseScreen({
    super.key,
    required this.selectedDrawerItem,
    this.body,
    this.onLogout,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  String _selectedMenu = 'Dashboard';
  late Widget _currentBody;
  late String _currentTitle;

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.selectedDrawerItem.isNotEmpty ? widget.selectedDrawerItem : 'Dashboard';
    _currentBody = widget.body ?? const DashboardScreen();
  }

  void _onMenuSelected(String menu) {
    setState(() {
      _selectedMenu = menu;
      _currentTitle = menu;
      switch (menu) {
        case 'Dashboard':
          _currentBody = const DashboardScreen();
          break;
        case 'Resource Allocation':
          _currentBody = const ResourceAllocationScreen();
          break;
        case 'Time Keeping':
          _currentBody = const TimeAllocationScreen();
          break;
        case 'Project Data':
          _currentBody = const ProjectDataScreen();
          break;
        case 'Logout':
          widget.onLogout?.call(context); // Pass BaseScreen's context
          break;
        default:
          _currentBody = const DashboardScreen();
      }
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF1C1C1C),
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1C),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildRadioListTile('Dashboard'), // Changed to use Group_32151.png
                    const SizedBox(height: 8), // Added spacing
                    _buildRadioListTile('Resource Allocation'),
                    const SizedBox(height: 8), // Added spacing
                    _buildRadioListTile('Time Keeping'), // Using existing asset for time keeping
                    const SizedBox(height: 8), // Added spacing
                    _buildRadioListTile('Project Data'),
                    const SizedBox(height: 8), // Added spacing
                    const Divider(color: Colors.white54),
                    const SizedBox(height: 8), // Added spacing
                    _buildRadioListTile('Logout'), // No icon for logout
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar( // Reverted to standard AppBar
        backgroundColor: const Color(0xFF1C1C1C), // App bar background color
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                'assets/images/24.png', // Your custom drawer icon
                color: Colors.white,
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Image.asset(
          'assets/images/logo.png', // Your app bar logo
          height: 24,
          fit: BoxFit.contain,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              child: Image.asset(
                'assets/images/account_icon.png', // Your account icon
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      body: Stack( // Reverted to Stack for background and blinking image
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroud.png', // Full screen background image
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _currentTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: _currentBody), // The content of the selected screen
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlinkingImage(
              imagePath: 'assets/images/discs.png', // Blinking image at the bottom
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioListTile(String title) {
    return ListTile(
      title: Container(
        decoration: BoxDecoration(
          color: _selectedMenu == title ? const Color(0xFFe91e63) : const Color(0x33e91e63), // Apply color directly to container
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Add padding for visual spacing
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold
          ), // Bold text for better visibility
        ),
      ),
      onTap: () {
        _onMenuSelected(title);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0), // Set horizontal padding for ListTile
    );
  }
}
