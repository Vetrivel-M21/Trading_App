import 'package:flutter/material.dart';
import 'package:trade_app/common/login_page.dart';
import 'package:trade_app/user/user_page.dart';
import 'package:trade_app/user/views/register_page.dart';
import 'user/views/register_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),

          //  'FT' : "/userpage",
          // 'AD' : "/admin",
          // 'BO' : "/backofficer",
          // 'BI' : "/biller",
          // 'AP' : "/approver"
      initialRoute: '/login',
      routes: {
        "/register" : (context)=>UserRegisterPage(),
        "/login" : (context) => LoginPage(),
        '/user' : (context) => UserPage(),
      },
    );
  }
}