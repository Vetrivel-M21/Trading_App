import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trade_app/service/service.dart';
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
  String? client_name;
  List<Map<String, dynamic>> soldStocks = [];
  Map<dynamic, dynamic>? userData;
  AppService appService = AppService();

  List<Widget> get bottomNavPages => [
    UserHomePage(),
    MyStoks(
      onSoldStocksChanged: (List<Map<String, dynamic>> updatedSoldStocks) {
        setState(() {
          soldStocks = updatedSoldStocks;
        });
      },
    ),
    HistoryPage(soldStocks: soldStocks),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // late Map<dynamic, dynamic> userInformation;

  // get appService => null;

  void getUserData() async {
    String? client_id = await UserStorage.getClientId();
    print(client_id);
    String? client_pass = await UserStorage.getClientPass();
    print(client_pass);
    Map<String, dynamic> loginData = {
      'client_id': client_id,
      'password': client_pass,
    };
    print(loginData);

    appService.UserlogIn(loginData)
        .then((response) async {
          if (jsonDecode(response.body)['status'] == 'S') {
            print("hi::::::::::::::");
            final decodedResponse = jsonDecode(response.body);
            if (decodedResponse is Map<String, dynamic> &&
                decodedResponse['resp'] is Map) {
              var userMap = decodedResponse['resp'] as Map;
              // print(userMap);
              setState(() {
                
              });
              userData = userMap;
              print(userData);
              // print(UserInfomation);
            }
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Data losed")));
          }
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("An error occurred: $error")));
        });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // @override
  // void didUpdateWidget(covariant UserPage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if(userData== null) getUserData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Trading App"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Container(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              UserStorage.clearClientId();
              UserStorage.clearClientPass();
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
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 70, 113, 148),
              ),
              child:
                  userData == null
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                userData!['first_name'] ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              if (userData!['kyc_completed'] == true)
                                Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: Colors.green,
                                ),
                            ],
                          ),
                          Text(userData!['email'] ?? ''),
                        ],
                      ),
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/profile",
                  // arguments: userInformation,
                );
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
