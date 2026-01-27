import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motorcycle_management/config.dart';

class ReviewPage extends StatelessWidget {
  // final String _name;
  // final String _email;
  // final String _role;
  // final String _level;
  // final bool _marketing;

  // const ReviewPage({
  //   super.key,
  //   required name,
  //   required email,
  //   required role,
  //   required level,
  //   required marketing,
  // }) : this._name = name,
  //      this._email = email,
  //      this._role = role,
  //      this._level = level,
  //      this._marketing = marketing;
  const ReviewPage({super.key});
  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object?>;
    return Scaffold(
      appBar: AppBar(title: Text("Review")),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'Name: ${arguments['name'] as String}\n'
                  'Email: ${arguments['email'] as String}\n'
                  'Role: ${arguments['role'] as String}\n'
                  'Level: ${arguments['level'] as String}\n'
                  'Marketing: ${arguments['marketing'] as bool == true ? 'yes' : 'no'}',
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("back"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  List<String> levels = ["Beginner", "Intermediate", "Advanced Level"];
  String _level = "Beginner";
  bool _obscure = true;
  String? _role = 'Student';
  bool _marketing = false;
  bool _terms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'empty value';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  border: OutlineInputBorder(),
                ),
                obscureText: _obscure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  try {
                    var response = await http.post(
                      Uri.parse("${config['apiUrl']}/auth/login"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },

                      body: jsonEncode({
                        "username": _name.text,
                        "password": _password.text,
                      }),
                    );
                    if (response.statusCode != 200 || response.body == 'false') {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                      return;
                    }
                    Navigator.pushNamedAndRemoveUntil(context, '/home',
                    (_) => false
                    );
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text("login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
