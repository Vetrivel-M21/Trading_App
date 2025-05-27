import 'package:flutter/material.dart';
import 'package:trade_app/service/user_storage.dart';
import 'package:trade_app/user/views/history.dart';
import 'package:trade_app/user/views/my_stoks.dart';
import 'package:trade_app/user/views/user_home_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;
  List<Widget> bottomNavPages = [UserHomePage(), MyStoks(), HistoryPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late Map<dynamic, dynamic> userInformation;

  // This method is used to get the user information from the previous page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<dynamic, dynamic>) {
      userInformation = args;
      if (userInformation.containsKey('client_id')) {
        UserStorage.saveClientId(userInformation['client_id'].toString());
      }
    } else {
      userInformation = {'first_name': 'Guest', 'email': 'guest@example.com'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trading App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: UserAccountsDrawerHeader(
                accountName: Text(userInformation['first_name']),
                accountEmail: Text(userInformation['email']),
              ),
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pushNamed(context, "/profile");
              },
            ),

            ListTile(
              title: Text("LogOut"),
              leading: Icon(Icons.logout),
              onTap: () {
                Navigator.pushNamed(context, "/login");
              },
            ),
          ],
        ),
      ),

      body: bottomNavPages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'My Stocks',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
            backgroundColor: Colors.blue,
          ),
        ],

        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
