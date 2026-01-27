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

  final List<Widget> _pages = [
    HomeTab(),
    MotorcyclesTab(),
    ChatTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Home Page")),
      body: _pages[_currentIndex], // 👈 switch content here
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle),
            label: "Motorcycles",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1, // width / height
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Card(elevation: 4, child: Center(child: Text('Item $index')));
      },
    );
  }
}

class MotorcyclesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Motorcycles"));
  }
}

class ChatTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Chat"));
  }
}

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, '/start', (_) => false);
      },
      child: Text("logout"),
    );
  }
}

