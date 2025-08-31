import 'package:flutter/material.dart';

// This is the custom drawer widget for your navigation menu.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // A dark background color for the drawer.
      backgroundColor: const Color(0xFF2d2d2d),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // The header of the drawer with the Khonology logo.
          DrawerHeader(
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
          ),
          
          // Dashboard menu item with custom icon.
          ListTile(
            leading: Image.asset(
              'assets/images/Group_32151.png',
              width: 30,
              height: 30,
            ),
            title: const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              // TODO: Navigate to the Dashboard screen
              Navigator.pop(context); // Close the drawer
            },
          ),

          // Resource Allocation menu item with custom icon.
          ListTile(
            leading: Image.asset(
              'assets/images/allocations.png',
              width: 30,
              height: 30,
            ),
            title: const Text(
              'Resource Allocation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              // TODO: Navigate to the Resource Allocation screen
              Navigator.pop(context);
            },
          ),
          
          // Time Keeping menu item with custom icon.
          ListTile(
            leading: Image.asset(
              'assets/images/time_keeping.png',
              width: 30,
              height: 30,
            ),
            title: const Text(
              'Time Keeping',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              // TODO: Navigate to the Time Keeping screen
              Navigator.pop(context);
            },
          ),
          
          // Project Data menu item with custom icon.
          ListTile(
            leading: Image.asset(
              'assets/images/project_data.png',
              width: 30,
              height: 30,
            ),
            title: const Text(
              'Project Data',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              // TODO: Navigate to the Project Data screen
              Navigator.pop(context);
            },
          ),
          
          // Logout menu item.
          ListTile(
            leading: Image.asset(
              'assets/images/logout.png',
              width: 30,
              height: 30,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              // TODO: Implement logout functionality
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// How to use the drawer in a Scaffold:
// In your main screen (e.g., DashboardScreen), you can add the drawer to the Scaffold.
/*
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      // This is where you add the custom drawer.
      drawer: const AppDrawer(),
      body: Center(
        child: Text('Main Screen Content'),
      ),
    );
  }
}
*/
