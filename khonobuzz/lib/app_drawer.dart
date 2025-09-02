import 'package:flutter/material.dart';
import 'package:khonobuzz/routes.dart';

// This is the custom drawer widget for your navigation menu.
class AppDrawer extends StatelessWidget {
  final VoidCallback? onLogout;
  const AppDrawer({super.key, this.onLogout});

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
            title: const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, AppRoutes.dashboard);
            },
          ),

          // Resource Allocation menu item with custom icon.
          ListTile(
            title: const Text(
              'Resource Allocation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.resourceAllocation);
            },
          ),
          
          // Time Keeping menu item with custom icon.
          ListTile(
            title: const Text(
              'Time Keeping',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.timeKeeping);
            },
          ),
          
          // Project Data menu item with custom icon.
          ListTile(
            title: const Text(
              'Project Data',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.projectData);
            },
          ),
          
          // Logout menu item.
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              onLogout?.call();
            },
          ),
        ],
      ),
    );
  }
}
