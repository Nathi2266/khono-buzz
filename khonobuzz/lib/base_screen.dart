import 'package:flutter/material.dart';
import 'package:khonobuzz/auth_screens.dart'; // Import BlinkingImage for the bottom animation

class BaseScreen extends StatefulWidget {
  final Widget body;
  final String titleText;

  const BaseScreen({
    Key? key,
    required this.body,
    required this.titleText,
  }) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/back-2.png', // Full screen background image
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Make scaffold background transparent
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(
              builder: (BuildContext builderContext) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(builderContext).openDrawer();
                  },
                );
              },
            ),
            title: Image.asset(
              'assets/images/logo.png', // Khonology logo
              width: 150,
            ),
            centerTitle: true,
            actions: [ // Removed 'const' from here
              // User profile icon
              Image.asset(
                'assets/images/account_icon.png',
                width: 30,
                height: 30,
                color: Colors.white, // Apply white color to the icon
              ),
              SizedBox(width: 15), // Spacing for the icon
            ],
          ),
          drawer: Drawer(
            backgroundColor: const Color(0xFF2D2D2D),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 50,
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  iconPath: 'assets/images/Group_32151.png', // Rocket icon for Dashboard
                  text: 'Dashboard',
                  routeName: '/dashboard',
                ),
                _buildDrawerItem(
                  context: context,
                  iconPath: 'assets/images/rescue_icon.png', // Rescue icon for Resource Allocation
                  text: 'Resource Allocation',
                  routeName: '/resource_allocation',
                ),
                _buildDrawerItem(
                  context: context,
                  iconPath: 'assets/images/time_keeping.png', // Time Keeping icon
                  text: 'Time Keeping',
                  routeName: '/time_allocation',
                ),
                _buildDrawerItem(
                  context: context,
                  iconPath: 'assets/images/project_data.png', // Project Data icon (changed from Group_32148.png)
                  text: 'Project Data',
                  routeName: '/project_data',
                ),
                _buildDrawerItem(
                  context: context,
                  iconPath: 'assets/images/logout.png',
                  text: 'Logout',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/Group_32151.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.titleText, // Use dynamic title text
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: widget.body, // The unique content for each screen
              ),
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
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    String? iconPath,
    IconData? iconIcon,
    required String text,
    String? routeName,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: iconPath != null
          ? Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: Colors.white,
            )
          : (iconIcon != null
              ? Icon(iconIcon, color: Colors.white, size: 24)
              : null),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (routeName != null) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}
