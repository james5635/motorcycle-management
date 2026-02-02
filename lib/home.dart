import 'package:flutter/material.dart';
import 'package:motorcycle_management/tab/setting/motorcycle.dart';
import 'package:motorcycle_management/tab/setting/setting.dart';

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

  final List<Widget> _pages = [
    HomeTab(),
    ProductGridScreen(),
    ChatTab(),
    ProfileSettingScreen(userId: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)["userId"]!)  ,
  ];

    
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



class ChatTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Chat"));
  }
}
