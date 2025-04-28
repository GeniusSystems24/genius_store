import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  final List<String> _availableLanguages = ['English', 'Arabic', 'Spanish', 'French'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Theme Section
            _buildSectionHeader(context, 'Appearance'),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable dark theme'),
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
                // Apply theme change
              },
            ),

            // Language settings
            ListTile(
              title: const Text('Language'),
              subtitle: Text(_selectedLanguage),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showLanguageSelector(context);
              },
            ),

            const Divider(),

            // Notifications Section
            _buildSectionHeader(context, 'Notifications'),
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive push notifications'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                // Apply notification settings
              },
            ),

            // Notification preferences
            _buildNotificationPreference(
              title: 'Order Updates',
              description: 'Get updates about your orders',
              defaultValue: true,
            ),

            _buildNotificationPreference(
              title: 'Promotions',
              description: 'Receive promotions and special offers',
              defaultValue: true,
            ),

            _buildNotificationPreference(
              title: 'Product Updates',
              description: 'Updates about products you viewed',
              defaultValue: false,
            ),

            const Divider(),

            // Privacy Section
            _buildSectionHeader(context, 'Privacy & Security'),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to change password screen
              },
            ),

            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to privacy policy
              },
            ),

            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to terms of service
              },
            ),

            const Divider(),

            // Account Section
            _buildSectionHeader(context, 'Account'),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Account Information'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to account information
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete Account'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showDeleteAccountConfirmation();
              },
            ),

            const SizedBox(height: 50),

            // App version
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'App Version: 1.0.0',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildNotificationPreference({
    required String title,
    required String description,
    required bool defaultValue,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SwitchListTile(
          title: Text(title),
          subtitle: Text(description),
          value: defaultValue,
          onChanged: (value) {
            setState(() {
              // This only updates the UI state for this specific preference
              // In a real app, you would store this in state management
            });
          },
        );
      },
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _availableLanguages.length,
              itemBuilder: (context, index) {
                final language = _availableLanguages[index];
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                    // Apply language change
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Process account deletion
                // After successful deletion, navigate to login screen
                AppRouter.replace(context, AppConstants.loginRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
