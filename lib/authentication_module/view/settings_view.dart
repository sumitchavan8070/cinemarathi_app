import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/constants/get_package_info.dart';
import 'package:school_management/utils/navigation/navigator.dart';
import 'package:school_management/utils/navigation/go_paths.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool notificationsEnabled = true;
  bool emailNotifications = true;
  bool pushNotifications = true;
  String selectedLanguage = "English";
  final List<String> languages = ["English", "Marathi", "Hindi"];

  String appVersion = "1.0.0";
  String buildNumber = "1";

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
    _loadSettings();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    } catch (e) {
      print("Error loading app info: $e");
    }
  }

  void _loadSettings() {
    // Load saved settings from storage
    notificationsEnabled = corePrefs.read("notifications_enabled") ?? true;
    emailNotifications = corePrefs.read("email_notifications") ?? true;
    pushNotifications = corePrefs.read("push_notifications") ?? true;
    selectedLanguage = corePrefs.read("selected_language") ?? "English";
  }

  void _saveSettings() {
    corePrefs.write("notifications_enabled", notificationsEnabled);
    corePrefs.write("email_notifications", emailNotifications);
    corePrefs.write("push_notifications", pushNotifications);
    corePrefs.write("selected_language", selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            MyNavigator.pop();
          },
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
        ),
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: const Color(0xFF0D0B1A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildSectionTitle("Notifications"),
            const SizedBox(height: 16),
            _buildSwitchTile(
              icon: Icons.notifications_outlined,
              title: "Enable Notifications",
              subtitle: "Receive notifications about updates and activities",
              value: true ,
              onChanged: (value) {

                return;
                // setState(() {
                //   notificationsEnabled = value;
                //   if (!value) {
                //     emailNotifications = false;
                //     pushNotifications = false;
                //   }
                //   _saveSettings();
                // });
              },
            ),
            if (notificationsEnabled) ...[
              const SizedBox(height: 12),
              _buildSwitchTile(
                icon: Icons.email_outlined,
                title: "Email Notifications",
                subtitle: "Receive notifications via email",
                value: emailNotifications,
                onChanged: (value) {
                  setState(() {
                    emailNotifications = value;
                    _saveSettings();
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildSwitchTile(
                icon: Icons.phone_android_outlined,
                title: "Push Notifications",
                subtitle: "Receive push notifications on your device",
                value: pushNotifications,
                onChanged: (value) {
                  setState(() {
                    pushNotifications = value;
                    _saveSettings();
                  });
                },
              ),
            ],

            const SizedBox(height: 40),

            // Language Section
            _buildSectionTitle("Language"),
            const SizedBox(height: 16),
            _buildLanguageSelector(),

            const SizedBox(height: 40),

            // Account Section
            _buildSectionTitle("Account"),
            const SizedBox(height: 16),
            _buildSettingsTile(
              icon: Icons.delete_outline,
              title: "Clear Cache",
              subtitle: "Clear app cache and temporary files",
              onTap: () => _showClearCacheDialog(),
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              icon: Icons.logout_outlined,
              title: "Sign Out",
              subtitle: "Sign out from your account",
              onTap: () => _showSignOutDialog(),
              color: Colors.red,
            ),

            const SizedBox(height: 40),

            // About Section
            _buildSectionTitle("About"),
            const SizedBox(height: 16),
            _buildInfoTile(
              icon: Icons.info_outline,
              title: "App Version",
              value: "${CoreAppInfo().version} (${CoreAppInfo().buildNumber})",
            ),
            const SizedBox(height: 12),
            _buildInfoTile(
              icon: Icons.copyright_outlined,
              title: "Copyright",
              value: "© 2024 CineMarathi",
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              icon: Icons.description_outlined,
              title: "Terms & Conditions",
              subtitle: "Read our terms and conditions",
              onTap: () {
                MyNavigator.pushNamed(GoPaths.termsAndConditions);
              },
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              subtitle: "Read our privacy policy",
              onTap: () {
                MyNavigator.pushNamed(GoPaths.privacyPolicy);
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.purpleAccent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: languages.map((language) {
          final isSelected = language == selectedLanguage;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLanguage = language;
                _saveSettings();
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.purpleAccent.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.language,
                    color: isSelected ? Colors.purpleAccent : Colors.grey[400],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      language,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[400],
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Colors.purpleAccent,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (color ?? Colors.purpleAccent).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color ?? Colors.purpleAccent, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Clear Cache",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to clear all cached data? This will remove temporary files but won't affect your account data.",
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement cache clearing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cache cleared successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Sign Out",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to sign out? You'll need to sign in again to access your account.",
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear preferences and navigate to splash
              corePrefs.erase();
              // Navigate to splash/login
              MyNavigator.popUntilAndPushNamed(GoPaths.splash);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }
}

