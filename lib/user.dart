import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
                TextField(decoration: InputDecoration(labelText: "Full Name")),
                TextField(decoration: InputDecoration(labelText: "Password")),
                TextField(decoration: InputDecoration(labelText: "Email")),
                TextField(
                  decoration: InputDecoration(labelText: "Phone Number"),
                ),
                TextField(decoration: InputDecoration(labelText: "Address")),
                TextField(
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
                  onChanged: (String? newValue) {},
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("hi");
                    var response = await http.get(
                      Uri.parse("http://localhost:8080/user"),
                    );
                    print("response" + response.body);
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
