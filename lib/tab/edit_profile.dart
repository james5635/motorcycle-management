import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:motorcycle_management/config.dart';

// --- SCREEN 2: EDIT PROFILE ---
class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullName;
  late TextEditingController _email;
  late TextEditingController _phoneNumber;
  late TextEditingController _address;
  late TextEditingController _profileImageUrl;
  late String? _selectedRole;
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

  String? _validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a role';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    _fullName = TextEditingController(text: widget.user["fullName"]);
    _email = TextEditingController(text: widget.user["email"]);
    _phoneNumber = TextEditingController(text: widget.user["phoneNumber"]);
    _address = TextEditingController(text: widget.user["address"]);
    _profileImageUrl = TextEditingController(
      text: widget.user["profileImageUrl"],
    );

    _selectedRole = widget.user["role"];
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phoneNumber.dispose();
    _address.dispose();
    _profileImageUrl.dispose();

    super.dispose();
  }

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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Stack(
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
                          : NetworkImage(
                              "${config["apiUrl"]}/uploads/${_profileImageUrl.text}",
                            ),
                      radius: 100,
                    ),
                  ),

                  Positioned(
                    bottom: 10,
                    right: 10,

                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 18,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              TextFormField(
                controller: _fullName,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: _validateFullName,
              ),
              SizedBox(height: 10),
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
                value: _selectedRole,
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
                    _selectedRole = newValue;
                  });
                },
                validator: _validateRole,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  try {
                    var uri = Uri.parse(
                      "${config['apiUrl']}/user/${widget.user["userId"]}",
                    );

                    var request = http.MultipartRequest("PUT", uri);

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
                          "email": _email.text,
                          "phoneNumber": _phoneNumber.text,
                          "address": _address.text,
                          "role": _selectedRole,
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
                          content: Text("User updated successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(
                        context,
                        true,
                      ); // Return true to indicate profile was updated
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to update user"),
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
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
