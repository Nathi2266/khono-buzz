import 'package:flutter/material.dart';
import 'package:khonobuzz/auth_screens.dart'; // For BlinkingImage widget
import 'package:khonobuzz/dashboard_screen.dart';
import 'package:khonobuzz/resource_allocation_screen.dart';
import 'package:khonobuzz/time_allocation_screen.dart';
import 'package:khonobuzz/project_data_screen.dart';

class BaseScreen extends StatefulWidget {
  final String titleText;
  final Widget? body;

  const BaseScreen({
    super.key,
    required this.titleText,
    this.body,
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
    _currentTitle = widget.titleText.isNotEmpty ? widget.titleText : 'Dashboard';
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
          // Implement logout logic here or navigate to login screen
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
                child: Row(
                  children: [
                    Flexible( // Prevent overflow
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildRadioListTile('Dashboard', 'assets/images/rocket_icon.png'),
                    _buildRadioListTile('Resource Allocation', 'assets/images/rocket_icon.png'),
                    _buildRadioListTile('Time Keeping', 'assets/images/rocket_icon.png'),
                    _buildRadioListTile('Project Data', 'assets/images/rocket_icon.png'),
                    const Divider(color: Colors.white54),
                    _buildRadioListTile('Logout', 'assets/images/rocket_icon.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        title: Image.asset(
          'assets/images/logo.png',
          height: 24,
          fit: BoxFit.contain,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroud.png',
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
                Expanded(child: _currentBody),
              ],
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

  Widget _buildRadioListTile(String title, String iconPath) {
    return RadioListTile<String>(
      value: title,
      groupValue: _selectedMenu,
      activeColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onChanged: (value) {
        if (value != null) {
          _onMenuSelected(value);
        }
      },
      secondary: SizedBox(
        width: 24,
        height: 24,
        child: Image.asset(
          iconPath,
          color: Colors.white,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.circle, color: Colors.white, size: 24);
          },
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    );
  }
}
