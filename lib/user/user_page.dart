import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  
  Map<dynamic, dynamic>? userInformation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accessing context here, after the widget is fully initialized
    final Map<dynamic, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>? ?? {};
    if(args !=  null){
      setState(() {
        userInformation = args;
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trading App"),
        
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: UserAccountsDrawerHeader(
              accountName: Text(userInformation!['first_name']), 
              accountEmail: Text(userInformation!['email'])
            )
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(Icons.home),
            ),

            ListTile(
              title: Text("LogOut"),
              leading: Icon(Icons.logout),
            )
          ],
        ),
      ),

    );
  }
}