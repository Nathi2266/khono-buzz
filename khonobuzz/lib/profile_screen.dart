import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController(text: 'John Doe');
  final TextEditingController _bioController = TextEditingController(text: 'Flutter developer and tech enthusiast.');
  final TextEditingController _locationController = TextEditingController(text: 'New York, USA');
  final TextEditingController _usernameController = TextEditingController(text: 'johndoe123');
  final TextEditingController _emailController = TextEditingController(text: 'john.doe@example.com');
  final TextEditingController _passwordController = TextEditingController(text: '********'); // Note: Passwords are not stored in Firestore directly
  final TextEditingController _linkedinController = TextEditingController(text: 'linkedin.com/in/johndoe');
  final TextEditingController _twitterController = TextEditingController(text: '@johndoe_dev');
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
        setState(() {
          _fullNameController.text = data['fullName'] ?? '';
          _bioController.text = data['bio'] ?? '';
          _locationController.text = data['location'] ?? '';
          _usernameController.text = data['username'] ?? '';
          _emailController.text = data['email'] ?? '';
          _linkedinController.text = data['linkedin'] ?? '';
          _twitterController.text = data['twitter'] ?? '';
          _jobTitleController.text = data['jobTitle'] ?? '';
          _companyController.text = data['company'] ?? '';
          // _passwordController is not loaded as passwords are not stored directly
          // For notification preferences, you would also load them here if you had a UI for them
        });
      }
    } catch (e) {
      print('Error loading profile data: $e');
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
    _linkedinController.dispose();
    _twitterController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
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
      'twitter': _twitterController.text,
      'lastUpdated': FieldValue.serverTimestamp(),
      // Add other fields as needed, e.g., 'profilePictureUrl', 'notificationPreferences'
    };

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        profileData, 
        SetOptions(merge: true), // Use merge: true to update existing fields without overwriting the entire document
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen or landing screen after logout
      // You might need to adjust your navigation based on your app's routing setup
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login', // Assuming '/login' is your login route
        (Route<dynamic> route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
        _buildTextFieldWithLabel('Twitter', _twitterController, Icons.link),
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
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color.fromARGB(255, 117, 102, 222), width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[100],
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
          const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  // Implement password visibility toggle
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color.fromARGB(255, 117, 102, 222), width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[100],
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
          Text('Notification Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
          Icon(Icons.arrow_forward_ios, size: 16),
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
            backgroundColor: const Color.fromARGB(255, 117, 102, 222),
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
        OutlinedButton(
          onPressed: _logout,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            side: const BorderSide(color: Color.fromARGB(255, 117, 102, 222)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 117, 102, 222)),
          ),
        ),
      ],
    );
  }
}
