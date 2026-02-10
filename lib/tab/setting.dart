import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motorcycle_management/config.dart';
import 'package:motorcycle_management/tab/edit_profile.dart';
import 'package:motorcycle_management/tab/favorites_screen.dart';

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
                          subtitle: "Change profile picture and E-mail",
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
                        SettingsTile(
                          icon: Icons.lock_outline,
                          title: "Change Password",
                          subtitle: "Update and strengthen account security",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen(
                                  userId: widget.userId,
                                  user: snapshot.data!["user"],
                                ),
                              ),
                            );
                          },
                        ),
                        SettingsTile(
                          icon: Icons.favorite,
                          title: "My Favorites",
                          subtitle: "View your saved products",
                          iconColor: Colors.red,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FavoritesScreen(),
                              ),
                            );
                          },
                        ),
                        SettingsTile(
                          icon: Icons.shopping_bag_outlined,
                          title: "My Orders",
                          subtitle: "View your order history",
                          iconColor: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrdersListScreen(userId: widget.userId),
                              ),
                            );
                          },
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
                          subtitle: "Frequently Asked Questions",
                        ),
                        SettingsTile(
                          icon: Icons.shield_outlined,
                          title: "Terms of Use",
                          subtitle: "Agreement between user and developer",
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Terms of Use'),
                                  content: SingleChildScrollView(
                                    child: Text(
                                      'Apache License\nVersion 2.0, January 2004\nhttp://www.apache.org/licenses/\n\nTERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION\n\n1. Definitions.\n\n   "License" shall mean the terms and conditions for use, reproduction,\n   and distribution as defined by Sections 1 through 9 of this document.\n\n   "Licensor" shall mean the copyright owner or entity authorized by\n   the copyright owner that is granting the License.\n\n   "You" (or "Your") shall mean an individual or Legal Entity\n   exercising permissions granted by this License.\n\n   "Source" form shall mean the preferred form for making modifications,\n   including but not limited to software source code, documentation\n   source, and configuration files.\n\n   "Object" form shall mean any form resulting from mechanical\n   transformation or translation of a Source form, including but\n   not limited to compiled object code, generated documentation,\n   and conversions to other media types.\n\n   "Work" shall mean the work of authorship, whether in Source or\n   Object form, made available under the License, as indicated by a\n   copyright notice that is included in or attached to the work\n   (an example is provided in the Appendix below).\n\n   "Derivative Works" shall mean any work, whether in Source or Object\n   form, that is based on (or derived from) the Work and for which the\n   editorial revisions, annotations, elaborations, or other modifications\n   represent, as a whole, an original work of authorship. For the purposes\n   of this License, Derivative Works shall not include works that remain\n   separable from, or merely link (or bind by name) to the interfaces of,\n   the Work and Derivative Works thereof.\n\n   "Contribution" shall mean any work of authorship, including\n   the original version of the Work and any modifications or additions\n   to that Work or Derivative Works thereof, that is intentionally\n   submitted to Licensor for inclusion in the Work by the copyright owner\n   or by an individual or Legal Entity authorized to submit on behalf of\n   the copyright owner. For the purposes of this definition, "submitted"\n   means any form of electronic, verbal, or written communication sent\n   to the Licensor or its representatives, including but not limited to\n   communication on electronic mailing lists, source code control systems,\n   and issue tracking systems that are managed by, or on behalf of, the\n   Licensor for the purpose of discussing and improving the Work, but\n   excluding communication that is conspicuously marked or otherwise\n   designated in writing by the copyright owner as "Not a Contribution."\n\n   "Contributor" shall mean Licensor and any individual or Legal Entity\n   on behalf of whom a Contribution has been received by Licensor and\n   subsequently incorporated within the Work.\n\n2. Grant of Copyright License. Subject to the terms and conditions of\n   this License, each Contributor hereby grants to You a perpetual,\n   worldwide, non-exclusive, no-charge, royalty-free, irrevocable\n   copyright license to reproduce, prepare Derivative Works of,\n   publicly display, publicly perform, sublicense, and distribute the\n   Work and such Derivative Works in Source or Object form.\n\n3. Grant of Patent License. Subject to the terms and conditions of\n   this License, each Contributor hereby grants to You a perpetual,\n   worldwide, non-exclusive, no-charge, royalty-free, irrevocable\n   (except as stated in this section) patent license to make, have made,\n   use, offer to sell, sell, import, and otherwise transfer the Work,\n   where such license applies only to those patent claims licensable\n   by such Contributor that are necessarily infringed by their\n   Contribution(s) alone or by combination of their Contribution(s)\n   with the Work to which such Contribution(s) was submitted. If You\n   institute patent litigation against any entity (including a\n   cross-claim or counterclaim in a lawsuit) alleging that the Work\n   or a Contribution incorporated within the Work constitutes direct\n   or contributory patent infringement, then any patent licenses\n   granted to You under this License for that Work shall terminate\n   as of the date such litigation is filed.\n\n4. Redistribution. You may reproduce and distribute copies of the\n   Work or Derivative Works thereof in any medium, with or without\n   modifications, and in Source or Object form, provided that You\n   meet the following conditions:\n\n   (a) You must give any other recipients of the Work or\n       Derivative Works a copy of this License; and\n\n   (b) You must cause any modified files to carry prominent notices\n       stating that You changed the files; and\n\n   (c) You must retain, in the Source form of any Derivative Works\n       that You distribute, all copyright, patent, trademark, and\n       attribution notices from the Source form of the Work,\n       excluding those notices that do not pertain to any part of\n       the Derivative Works; and\n\n   (d) If the Work includes a "NOTICE" text file as part of its\n       distribution, then any Derivative Works that You distribute must\n       include a readable copy of the attribution notices contained\n       within such NOTICE file, excluding those notices that do not\n       pertain to any part of the Derivative Works, in at least one\n       of the following places: within a NOTICE text file distributed\n       as part of the Derivative Works; within the Source form or\n       documentation, if provided along with the Derivative Works; or,\n       within a display generated by the Derivative Works, if and\n       wherever such third-party notices normally appear. The contents\n       of the NOTICE file are for informational purposes only and\n       do not modify the License. You may add Your own attribution\n       notices within Derivative Works that You distribute, alongside\n       or as an addendum to the NOTICE text from the Work, provided\n       that such additional attribution notices cannot be construed\n       as modifying the License.\n\n   You may add Your own copyright statement to Your modifications and\n   may provide additional or different license terms and conditions\n   for use, reproduction, or distribution of Your modifications, or\n   for any such Derivative Works as a whole, provided Your use,\n   reproduction, and distribution of the Work otherwise complies with\n   the conditions stated in this License.\n\n5. Submission of Contributions. Unless You explicitly state otherwise,\n   any Contribution intentionally submitted for inclusion in the Work\n   by You to the Licensor shall be under the terms and conditions of\n   this License, without any additional terms or conditions.\n   Notwithstanding the above, nothing herein shall supersede or modify\n   the terms of any separate license agreement you may have executed\n   with Licensor regarding such Contributions.\n\n6. Trademarks. This License does not grant permission to use the trade\n   names, trademarks, service marks, or product names of the Licensor,\n   except as required for reasonable and customary use in describing the\n   origin of the Work and reproducing the content of the NOTICE file.\n\n7. Disclaimer of Warranty. Unless required by applicable law or\n   agreed to in writing, Licensor provides the Work (and each\n   Contributor provides its Contributions) on an "AS IS" BASIS,\n   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or\n   implied, including, without limitation, any warranties or conditions\n   of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A\n   PARTICULAR PURPOSE. You are solely responsible for determining the\n   appropriateness of using or redistributing the Work and assume any\n   risks associated with Your exercise of permissions under this License.\n\n8. Limitation of Liability. In no event and under no legal theory,\n   whether in tort (including negligence), contract, or otherwise,\n   unless required by applicable law (such as deliberate and grossly\n   negligent acts) or agreed to in writing, shall any Contributor be\n   liable to You for damages, including any direct, indirect, special,\n   incidental, or consequential damages of any character arising as a\n   result of this License or out of the use or inability to use the\n   Work (including but not limited to damages for loss of goodwill,\n   work stoppage, computer failure or malfunction, or any and all\n   other commercial damages or losses), even if such Contributor\n   has been advised of the possibility of such damages.\n\n9. Accepting Warranty or Additional Liability. While redistributing\n   the Work or Derivative Works thereof, You may choose to offer,\n   and charge a fee for, acceptance of support, warranty, indemnity,\n   or other liability obligations and/or rights consistent with this\n   License. However, in accepting such obligations, You may act only\n   on Your own behalf and on Your sole responsibility, not on behalf\n   of any other Contributor, and only if You agree to indemnify,\n   defend, and hold each Contributor harmless for any liability\n   incurred by, or claims asserted against, such Contributor by reason\n   of your accepting such warranty or additional liability.\n\nEND OF TERMS AND CONDITIONS',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
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

// --- CHANGE PASSWORD SCREEN ---

class ChangePasswordScreen extends StatefulWidget {
  final int userId;
  final Map<String, dynamic> user;

  const ChangePasswordScreen({
    super.key,
    required this.userId,
    required this.user,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a password")));
      return;
    }
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse("${config['apiUrl']}/user/${widget.userId}"),
      );

      request.files.add(
        http.MultipartFile.fromString(
          'user',
          jsonEncode({
            "username":
                widget.user["username"] ?? widget.user["fullName"] ?? "user",
            "password": _passwordController.text,
          }),
          contentType: http.MediaType('application', 'json'),
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password changed successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to change password: $responseBody"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Change Password",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      hintText: "Enter new password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF6C63FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText: "Confirm new password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF6C63FF)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ORDERS SCREEN ---

class OrdersListScreen extends StatefulWidget {
  final int userId;
  const OrdersListScreen({super.key, required this.userId});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  late Future<List<dynamic>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  Future<List<dynamic>> _fetchOrders() async {
    final response = await http.get(
      Uri.parse("${config['apiUrl']}/order/user/${widget.userId}"),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load orders");
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      color: Color(0xFF6C63FF),
                      size: 24,
                    ),
                  ),
                  title: Text(
                    "Order #${order['orderId']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(order['orderDate']),
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: order['status'] == 'pending'
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          order['status'].toUpperCase(),
                          style: TextStyle(
                            color: order['status'] == 'pending'
                                ? Colors.orange
                                : Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    "\$${formatPrice(order['totalAmount'])}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OrderDetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<List<dynamic>> _orderItemsFuture;

  @override
  void initState() {
    super.initState();
    _orderItemsFuture = _fetchOrderItems();
  }

  Future<List<dynamic>> _fetchOrderItems() async {
    final response = await http.get(Uri.parse("${config['apiUrl']}/orderitem"));
    if (response.statusCode == 200) {
      final allItems = jsonDecode(response.body) as List;
      return allItems
          .where((item) => item['order']['orderId'] == widget.order['orderId'])
          .toList();
    } else {
      throw Exception("Failed to load order items");
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Order #${widget.order['orderId']}",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Order Status",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.order['status'] == 'pending'
                              ? Colors.orange.withValues(alpha: 0.1)
                              : Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.order['status'].toUpperCase(),
                          style: TextStyle(
                            color: widget.order['status'] == 'pending'
                                ? Colors.orange
                                : Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    "Order Date",
                    _formatDate(widget.order['orderDate']),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    "Total Amount",
                    "\$${formatPrice(widget.order['totalAmount'])}",
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    "Payment Method",
                    widget.order['paymentMethod'],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    "Shipping Address",
                    widget.order['shippingAddress'],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<dynamic>>(
              future: _orderItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No items in this order"));
                }

                final orderItems = snapshot.data!;

                return Column(
                  children: orderItems.map((item) {
                    final product = item['product'];
                    if (product == null) return const SizedBox.shrink();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "${config['apiUrl']}/uploads/${product['imageUrl']}",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Quantity: ${item['quantity']}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "\$${formatPrice(item['unitPrice'])} each",
                                  style: const TextStyle(
                                    color: Color(0xFF6C63FF),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "\$${formatPrice(item['unitPrice'] * item['quantity'])}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }
}
