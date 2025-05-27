import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  late Map<dynamic, dynamic> userInformation;

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<dynamic, dynamic>) {
      userInformation = args;
    } else {
      userInformation = {
        'first_name': 'Guest',
        'email': 'guest@example.com'
      };
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 200,
          color: Colors.blue,
          child: Center(
            child: Text(
              "Welcome ${userInformation['first_name']}",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }
}