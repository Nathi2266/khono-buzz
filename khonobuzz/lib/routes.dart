import 'package:flutter/material.dart';
import 'package:khonobuzz/dashboard_screen.dart';

class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String resourceAllocation = '/resource_allocation';
  static const String timeKeeping = '/time_keeping';
  static const String projectData = '/project_data';

  static Map<String, WidgetBuilder> get routes {
    return {
      dashboard: (context) => const DashboardScreen(),
      resourceAllocation: (context) => const PlaceholderScreen(title: 'Resource Allocation'),
      timeKeeping: (context) => const PlaceholderScreen(title: 'Time Keeping'),
      projectData: (context) => const PlaceholderScreen(title: 'Project Data'),
    };
  }
}

// Placeholder screen for routes that haven't been fully implemented yet.
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('This is the $title Screen'),
      ),
    );
  }
}
