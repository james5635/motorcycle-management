import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController _fullName = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _profileImageUrl = TextEditingController();
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Page")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _fullName,
                  decoration: InputDecoration(labelText: "Full Name"),
                ),
                TextField(
                  controller: _password,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _phoneNumber,
                  decoration: InputDecoration(labelText: "Phone Number"),
                ),

                TextField(
                  controller: _address,
                  decoration: InputDecoration(labelText: "Address"),
                ),
                TextField(
                  controller: _profileImageUrl,
                  decoration: InputDecoration(labelText: "profileImageUrl"),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Role"),
                  items: <String>['customer', 'admin', 'guest']
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    var response = await http.post(
                      Uri.parse("http://localhost:8080/user"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode({
                        "fullName": _fullName.text,
                        "passwordHash": _password.text,
                        "email": _email.text,
                        "phoneNumber": _phoneNumber.text,
                        "address": _address.text,
                        "profileImageUrl": _profileImageUrl.text,
                        "role": selectedRole,
                        "createdAt": DateTime.now().toIso8601String(),
                      }),
                    );
                    print(response.body);
                  },
                  child: Text("Create account"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
