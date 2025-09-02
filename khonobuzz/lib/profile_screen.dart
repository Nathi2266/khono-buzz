import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khonobuzz/password_strength_meter.dart'; // Import the new widget
import 'dart:ui'; // Import for ImageFilter

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController(text: 'John Doe');
  final TextEditingController _bioController = TextEditingController(text: 'Flutter developer and tech enthusiast.');
  final TextEditingController _locationController = TextEditingController(text: 'New York, USA');
  final TextEditingController _usernameController = TextEditingController(text: 'johndoe123');
  final TextEditingController _emailController = TextEditingController(text: 'john.doe@example.com');
  final TextEditingController _passwordController = TextEditingController(text: '********'); // Note: Passwords are not stored in Firestore directly
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController(text: 'linkedin.com/in/johndoe');
  final TextEditingController _xController = TextEditingController(text: '@johndoe_dev');
  final TextEditingController _jobTitleController = TextEditingController(text: 'Software Engineer');
  final TextEditingController _companyController = TextEditingController(text: 'TechCorp');

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        if (!mounted) return; // Guard against BuildContext use across async gaps
        setState(() {
          _fullNameController.text = data['fullName'] ?? '';
          _bioController.text = data['bio'] ?? '';
          _locationController.text = data['location'] ?? '';
          _usernameController.text = data['username'] ?? '';
          _emailController.text = data['email'] ?? '';
          _linkedinController.text = data['linkedin'] ?? '';
          _xController.text = data['x'] ?? '';
          _jobTitleController.text = data['jobTitle'] ?? '';
          _companyController.text = data['company'] ?? '';
          // _passwordController is not loaded as passwords are not stored directly
          // For notification preferences, you would also load them here if you had a UI for them
        });
      }
    } catch (e) {
      debugPrint('Error loading profile data: $e'); // Change print to debugPrint
      if (!mounted) return; // Guard against BuildContext use across async gaps
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data: $e')),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _linkedinController.dispose();
    _xController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return; // Guard against BuildContext use across async gaps
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to save profile!')),
      );
      return;
    }

    final profileData = {
      'fullName': _fullNameController.text,
      'bio': _bioController.text,
      'location': _locationController.text,
      'username': _usernameController.text,
      'email': _emailController.text, // Often already in Firebase Auth, but good to keep in profile too
      'jobTitle': _jobTitleController.text,
      'company': _companyController.text,
      'linkedin': _linkedinController.text,
      'x': _xController.text,
      'lastUpdated': FieldValue.serverTimestamp(),
      // Add other fields as needed, e.g., 'profilePictureUrl', 'notificationPreferences'
    };

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        profileData, 
        SetOptions(merge: true), // Use merge: true to update existing fields without overwriting the entire document
      );
      if (!mounted) return; // Guard against BuildContext use across async gaps
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      if (!mounted) return; // Guard against BuildContext use across async gaps
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  void _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to change password!')),
      );
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password cannot be empty.')),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password and confirm password do not match.')),
      );
      return;
    }

    try {
      await user.updatePassword(_newPasswordController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully! Please re-login with your new password.')),
      );
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen or landing screen after logout
      // You might need to adjust your navigation based on your app's routing setup
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login', // Assuming '/login' is your login route
        (Route<dynamic> route) => false,
      );
      if (!mounted) return; // Guard against BuildContext use across async gaps
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully!')),
      );
    } catch (e) {
      if (!mounted) return; // Guard against BuildContext use across async gaps
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Change icon color to white
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white), // Change title color to white
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true, // Extend body behind the app bar
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_2.png', // Your specified background image
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildProfileImage(),
                  const SizedBox(height: 30),
                  _buildInfoSection(),
                  const SizedBox(height: 30),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Color.fromARGB(255, 220, 215, 245),
            child: Icon(Icons.person, size: 80, color: Colors.black45),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 117, 102, 222),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldWithLabel('Full Name', _fullNameController, Icons.person),
        _buildTextFieldWithLabel('Bio', _bioController, Icons.edit_note, maxLines: 3),
        _buildTextFieldWithLabel('Location', _locationController, Icons.location_on),
        _buildTextFieldWithLabel('Username', _usernameController, Icons.person),
        _buildTextFieldWithLabel('Email Address', _emailController, Icons.email),
        _buildPasswordChangeField(),
        _buildTextFieldWithLabel('LinkedIn', _linkedinController, Icons.link),
        _buildTextFieldWithLabel('X', _xController, Icons.link),
        _buildTextFieldWithLabel('Job Title', _jobTitleController, Icons.work),
        _buildTextFieldWithLabel('Company', _companyController, Icons.business),
        _buildNotificationPreferences(),
        _buildAccountDeletion(),
      ],
    );
  }

  Widget _buildTextFieldWithLabel(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), // Set text color to white
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // Apply border radius to the blur effect
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Apply blur effect
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                style: const TextStyle(color: Colors.white), // Ensure text is visible
                decoration: InputDecoration(
                  prefixIcon: Icon(icon, color: Colors.white70), // Adjust icon color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // No border side for a cleaner blur look
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // No border side
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFe91e63), width: 2), // Focus border color
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0.1), // Changed from withOpacity
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordChangeField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Password', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), // Set text color to white
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // Apply border radius to the blur effect
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Apply blur effect
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white), // Ensure text is visible
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70), // Adjust icon color
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.white70), // Adjust icon color
                    onPressed: () {
                      // Implement password visibility toggle
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // No border side for a cleaner blur look
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // No border side
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFe91e63), width: 2), // Focus border color
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0.1), // Changed from withOpacity
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('New Password', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), // Set text color to white
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // Apply border radius to the blur effect
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Apply blur effect
              child: TextField(
                controller: _newPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white), // Ensure text is visible
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_open, color: Colors.white70), // Adjust icon color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // No border side for a cleaner blur look
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // No border side
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFe91e63), width: 2), // Focus border color
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0.1), // Changed from withOpacity
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          PasswordStrengthMeter(password: _newPasswordController.text),
          const SizedBox(height: 20),
          const Text('Confirm New Password', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), // Set text color to white
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // Apply border radius to the blur effect
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Apply blur effect
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white), // Ensure text is visible
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_reset, color: Colors.white70), // Adjust icon color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // No border side for a cleaner blur look
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // No border side
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFe91e63), width: 2), // Focus border color
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0.1), // Changed from withOpacity
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPreferences() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Notification Preferences', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), // Set text color to white
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildAccountDeletion() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Account Deletion', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFe91e63), // Changed to match auth screens
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _changePassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFe91e63), // Changed to match auth screens
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Change Password',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: _logout,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            side: const BorderSide(color: Color(0xFFe91e63)), // Changed to match auth screens
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            foregroundColor: Colors.white, // Change text color to white
          ),
          child: const Text(
            'Logout',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
