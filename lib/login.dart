import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
      routes: {'/review': (context) => ReviewPage()},
    );
  }
}

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        title: Text("Register"),
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
                  labelText: 'Full name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null) {
                    // return 'null value';
                  }
                  if (value.isEmpty) {
                    return 'empty value';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
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
              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                initialValue: _role, //        value: _role,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: const ['Student', 'Developer', 'Designer']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _role = v),
                validator: (v) => v == null ? 'Select a role' : null,
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: RadioGroup(
                      groupValue: _level,
                      onChanged: (value) {
                        setState(() {
                          _level = value!;
                        });
                      },
                      child: Column(
                        children: levels.map((level) {
                          return RadioListTile<String>(
                            value: level,
                            title: Text(level),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 0,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        'Experience Level',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              SwitchListTile(
                value: _marketing,
                onChanged: (v) => setState(() => _marketing = v),
                title: const Text('Receive product updates'),
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
              SizedBox(height: 5),

              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate() || !_terms) {
                    return;
                  }

                  Navigator.pushNamed(
                    context,
                    "/review",
                    arguments: {
                      "name": _name.text,
                      "email": _email.text,
                      "role": _role,
                      "level": _level,
                      "marketing": _marketing,
                    },
                  );
                },
                child: Text("create account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
