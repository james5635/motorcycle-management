import 'package:flutter/material.dart';
import 'package:motorcycle_management/home.dart';
import 'package:motorcycle_management/login.dart';
import 'package:motorcycle_management/tab/edit_profile.dart';
import 'package:motorcycle_management/start.dart';
import 'package:motorcycle_management/user.dart';

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
      home: const StartPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/review': (context) => ReviewPage(),
        '/user': (context) => UserPage(),
        '/login': (context) => LoginPage(),
        '/start': (context) => StartPage(),
      },
    );
  }
}
