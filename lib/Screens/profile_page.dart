import 'package:flutter/material.dart';
import 'package:plant_app/widgets/custom_app_bar.dart';
import 'package:plant_app/widgets/profile_btn_card.dart';
import 'package:plant_app/widgets/profile_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileCard(),
      body: SafeArea(
        child: Column(
          children: [
            // Menu Options
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    // Edit Profile Button
                    _buildMenuButton(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      color: const Color(0xFF0D483B),
                      onTap: () {},
                    ),

                    const SizedBox(height: 16),

                    // Settings Button
                    _buildMenuButton(
                      icon: Icons.settings,
                      title: 'Settings',
                      color: const Color(0xFF0D483B),
                      onTap: () {},
                    ),

                    const SizedBox(height: 16),

                    // Export Report Button
                    _buildMenuButton(
                      icon: Icons.download,
                      title: 'Export Report',
                      color: const Color(0xFF0D483B),
                      onTap: () {},
                    ),

                    const SizedBox(height: 16),

                    // Logout Button
                    _buildMenuButton(
                      icon: Icons.logout,
                      title: 'Logout',
                      color: const Color(0xFF80B7A2),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menu Button Widget
  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
