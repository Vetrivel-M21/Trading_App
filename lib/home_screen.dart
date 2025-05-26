import 'package:flutter/material.dart';
import 'package:trade_app/admin/admin.dart';

import 'package:trade_app/clients/backOfficer/back_officer.dart';
import 'package:trade_app/common/login_page.dart';
import 'package:trade_app/user/user_page.dart';
import 'package:trade_app/user/views/profile.dart';
import 'package:trade_app/user/views/register_page.dart';
import 'user/views/history.dart' show HistoryPage;
import 'user/views/my_stoks.dart' show MyStoks;
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

          // ["Admin", "BackOfficer", "Biller", "Approver"];
      initialRoute: '/login',
      routes: {
        "/register" : (context)=>UserRegisterPage(),
        "/login" : (context) => LoginPage(),
        '/user' : (context) => UserPage(),
        '/mystock' : (context) => MyStoks(),
        '/history' : (context) => HistoryPage(),
        '/Admin' : (context) => AdminPage(),
        '/BackOfficer' : (context)=> BackOfficer(),
        '/Biller' : (context) => BackOfficer(),
        '/Approver' : (context) => BackOfficer(),
        '/profile' : (context) => Profile(),
      },
    );
  }
}