import 'package:flutter/material.dart';
import 'list_page.dart';
import 'two_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();

  int indexBottomNavigationBar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Eduardo'),
              accountEmail: Text('dudu@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor:  Colors.greenAccent,
                child: Text('E'),
              ),
            ),
            ListTile(
              title: Text('Home'),
              trailing: Icon(Icons.home),
              onTap: () {
                _pageController.animateToPage(
                  0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
                Navigator.pop(context);
              },
            ),ListTile(
              title: Text('List'),
              trailing: Icon(Icons.list),
              onTap: () {
                _pageController.animateToPage(
                  1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
                Navigator.pop(context);
              },
            ),ListTile(
              title: Text('Profile'),
              trailing: Icon(Icons.person),
              onTap: () {
                _pageController.animateToPage(
                  2,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Column(
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.purple,
                child: Center(
                  child: Text(
                    'Olá mundo!',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 19, 12, 117),
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        'Container 1',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        'Container 2',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ListScreen(),
          TwoPage(),
        ],
      ),
      /*
       */
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexBottomNavigationBar,
        onTap: (int page) {
          setState(() {
            indexBottomNavigationBar = page;
          });
          _pageController.animateToPage(
            page,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
