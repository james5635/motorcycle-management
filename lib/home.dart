import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();  
  }

}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Column(
        children: [
          Text("Home Page"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
         type: BottomNavigationBarType.fixed, // Add this line
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.motorcycle), label: "Motorcycles"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}