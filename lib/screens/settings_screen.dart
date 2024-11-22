// TODO Implement this library.

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkModeEnabled = value;
      if (_darkModeEnabled) {
        // Enable dark mode
        Theme.of(context).copyWith(
          brightness: Brightness.dark,
        );
      } else {
        // Disable dark mode
        Theme.of(context).copyWith(
          brightness: Brightness.light,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.teal),
            title: Text('Enable Notifications'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
              activeColor: Colors.teal,
            ),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode, color: Colors.teal),
            title: Text('Enable Dark Mode'),
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: _toggleDarkMode,
              activeColor: Colors.teal,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.teal),
            title: Text('Account Information'),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
            onTap: () {
              // Navigate to account information page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountInformationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AccountInformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'User account information and settings can be managed here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
