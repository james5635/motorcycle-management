import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:motorcycle_management/config.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fullName = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _profileImageUrl = TextEditingController();
  String? selectedRole;

  bool _terms = false;
  XFile? _file;

  // Validation functions
  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    if (value.length < 5) {
      return 'Address must be at least 5 characters';
    }
    return null;
  }

  String? _validateProfileImageUrl(String? value) {
    if (value != null && value.isNotEmpty) {
      final urlRegex = RegExp(r'^https?://[^\s/$.?#].[^\s]*$');
      if (!urlRegex.hasMatch(value)) {
        return 'Please enter a valid URL';
      }
    }
    return null;
  }

  String? _validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a role';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Page")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      ImagePicker picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      setState(() {
                        _file = pickedFile;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      backgroundImage: _file != null
                          ? FileImage(File(_file!.path))
                          : null,
                      radius: 60,
                      child: _file == null
                          ? const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 40,
                            )
                          : null,
                    ),
                  ),
                  TextFormField(
                    controller: _fullName,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateFullName,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _password,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneNumber,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: _validatePhoneNumber,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _address,
                    decoration: InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateAddress,
                  ),

                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Role",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedRole,
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
                    validator: _validateRole,
                  ),
                  SizedBox(height: 10),

                  CheckboxListTile(
                    value: _terms,
                    onChanged: (v) => setState(() => _terms = v ?? false),
                    title: const Text('I agree to Terms'),
                    subtitle: !_terms
                        ? const Text(
                            'Required',
                            style: TextStyle(color: Colors.red),
                          )
                        : null,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate() || !_terms) {
                        return;
                      }

                      try {
                        var uri = Uri.parse("${config['apiUrl']}/user");

                        var request = http.MultipartRequest("POST", uri);

                        // // ✅ JSON part
                        // request.fields['user'] = jsonEncode({
                        //   "username": _fullName.text,
                        //   "password": _password.text,
                        //   "email": _email.text,
                        //   "phoneNumber": _phoneNumber.text,
                        //   "address": _address.text,
                        //   "role": selectedRole,
                        // });

                    

                        // Instead of request.fields['user'] = ...
                        request.files.add(
                          http.MultipartFile.fromString(
                            'user',
                            jsonEncode({
                              "username": _fullName.text,
                              "password": _password.text,
                              "email": _email.text,
                              "phoneNumber": _phoneNumber.text,
                              "address": _address.text,
                              "role": selectedRole,
                            }),
                            contentType: http.MediaType(
                              'application',
                              'json',
                            ), // This adds the missing header!
                          ),
                        );


                        // ✅ Image part (optional)
                        if (_file != null) {
                          request.files.add(
                            await http.MultipartFile.fromPath(
                              'profileImage',
                              _file!.path,
                              contentType: http.MediaType(
                                'application',
                                'png',
                              ), // or png
                            ),
                          );
                        }

                        var response = await request.send();

                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("User created successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to create user"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text("Create account"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
