import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  ProfileScreen({required this.userId});

  void _editProfile(BuildContext context) {
    // Navigate to Edit Profile Screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen(userId: userId)),
    );
  }

  void _logout(BuildContext context) {
    // Add functionality to log out
    // This might include clearing user session and navigating to the login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://www.example.com/profile_picture'), // Replace with actual image URL
              ),
            ),
            SizedBox(height: 20),
            Text(
              'User ID: $userId',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildProfileField('Name', 'John Doe'),
            _buildProfileField('Email', 'john.doe@example.com'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _editProfile(context),
              child: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  final String userId;

  EditProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('Edit Profile for User ID: $userId'),
      ),
    );
  }
}
