import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motorcycle_management/config.dart';

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
                            builder: (context) => const EditProfileScreen(),
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

// --- SCREEN 2: EDIT PROFILE ---
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "EDIT PROFILE",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=scarlett',
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E272E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const CustomInput(label: "Name", hint: "Scarlett"),
            const CustomInput(label: "Nick Name", hint: "Davis"),
            CustomInput(
              label: "Email",
              hint: "Scarlettdavis@gmail.com",
              suffix: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const CustomInput(label: "Phone Number", hint: "555-1234-5678"),
            const CustomInput(label: "Date of birth", hint: "18.May.2001"),
          ],
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

class CustomInput extends StatelessWidget {
  final String label;
  final String hint;
  final Widget? suffix;

  const CustomInput({
    super.key,
    required this.label,
    required this.hint,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: suffix,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
