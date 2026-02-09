import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motorcycle_management/config.dart';
import 'package:motorcycle_management/tab/edit_profile.dart';

// --- SCREEN 1: PROFILE SETTING ---

class ProfileSettingScreen extends StatefulWidget {
  final int userId;
  const ProfileSettingScreen({super.key, required this.userId});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  late Future<Map<String, dynamic>> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    var user = await http.get(
      Uri.parse("${config['apiUrl']}/user/${widget.userId}"),
    );
    return {"user": jsonDecode(user.body)};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              "${config['apiUrl']}/uploads/${snapshot.data!["user"]["profileImageUrl"]}",
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!["user"]["fullName"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                snapshot.data!["user"]["email"],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    const SectionHeader(title: "General"),
                    SettingsCard(
                      children: [
                        SettingsTile(
                          icon: Icons.person_outline,
                          title: "Edit Profile",
                          subtitle: "Change profile picture, number, E-mail",
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  user: snapshot.data!["user"],
                                ),
                              ),
                            );
                            // Refresh data if profile was updated
                            if (result == true) {
                              setState(() {
                                _userFuture = _fetchUserData();
                              });
                            }
                          },
                        ),
                        const SettingsTile(
                          icon: Icons.lock_outline,
                          title: "Change Password",
                          subtitle: "Update and strengthen account security",
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),
                    const SectionHeader(title: "Preferences"),
                    SettingsCard(
                      children: [
                        const SettingsTile(
                          icon: Icons.help_outline,
                          title: "FAQ",
                          subtitle: "Securely add payment method",
                        ),
                        const SettingsTile(
                          icon: Icons.shield_outlined,
                          title: "Terms of Use",
                          subtitle: "Protect your account now",
                        ),
                        SettingsTile(
                          icon: Icons.logout,
                          title: "Log Out",
                          subtitle: "Securely log out of Account",
                          titleColor: Colors.red,
                          iconColor: Colors.red,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Log Out'),
                                  content: const Text(
                                    'Are you sure you want to log out?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Close dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Close dialog
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/start',
                                          (_) => false,
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 100), // Bottom padding for scroll
                  ],
                );
              } else {
                return const Text('No data found');
              }
            },
          ),
        ),
      ),
    );
  }
}

// --- SHARED COMPONENTS ---

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const SettingsCard({super.key, required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Color? titleColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.titleColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? Colors.blue).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? Colors.blue, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: titleColor ?? Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}
