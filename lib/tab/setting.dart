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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child:  SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
          future: (() async {
            var user = await http.get(
              Uri.parse("${config['apiUrl']}/user/${widget.userId}"),
            );
            // var image = await http.get(
            //   Uri.parse("${config['apiUrl']}/uploads/${jsonDecode(user.body)["profileImageUrl"]}"),
            // );
            // print(image.statusCode);

            return {
              "user": jsonDecode(user.body),
              // "image": jsonDecode(image.body)
            };
          })(),
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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  EditProfileScreen(user: snapshot.data!["user"]),
                          ),
                        ),
                      ),
                      const SettingsTile(
                        icon: Icons.lock_outline,
                        title: "Change Password",
                        subtitle: "Update and strengthen account security",
                      ),
                      const SettingsTile(
                        icon: Icons.shield_outlined,
                        title: "Terms of Use",
                        subtitle: "Protect your account now",
                      ),
                      const SettingsTile(
                        icon: Icons.credit_card,
                        title: "Add Card",
                        subtitle: "Securely add payment method",
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const SectionHeader(title: "Preferences"),
                  SettingsCard(
                    children: [
                      SettingsTile(
                        icon: Icons.notifications_none,
                        title: "Notification",
                        subtitle: "Customize your notification preferences",
                        trailing: Switch(
                          value: true,
                          onChanged: (val) {},
                          activeColor: Colors.blue,
                        ),
                      ),
                      const SettingsTile(
                        icon: Icons.help_outline,
                        title: "FAQ",
                        subtitle: "Securely add payment method",
                      ),
                      SettingsTile(
                        icon: Icons.logout,
                        title: "Log Out",
                        subtitle: "Securely log out of Account",
                        titleColor: Colors.red,
                        iconColor: Colors.red,
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/start',
                            (_) => false,
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
    ));
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
