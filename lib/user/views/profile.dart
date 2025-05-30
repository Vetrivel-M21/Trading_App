import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trade_app/service/service.dart';
import 'package:trade_app/service/user_storage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

@override
class _ProfileState extends State<Profile> {
  late Map<dynamic, dynamic> userInformation;
  Map<dynamic, dynamic>? userData;
  AppService appService = AppService();
  // @override
  //  void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final args = ModalRoute.of(context)?.settings.arguments;
  //   if (args != null && args is Map<dynamic, dynamic>) {
  //     userInformation = args;
  //   } else {
  //     userInformation = {'first_name': 'Guest', 'email': 'guest@example.com', 'last_name':'G'};
  //   }
  // }

   @override
  void initState() {
    super.initState();
    getUserData();
  }


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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: userData==null? Center(child: CircularProgressIndicator(),):Container(
        padding: EdgeInsets.all(20),
        color: const Color.fromARGB(255, 162, 175, 185),
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
            ),
            width:  MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  
                  radius: 70,
                  backgroundImage: AssetImage('profile.jpg'),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(7.0)
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text("Name"),
                                Text("${userData!['first_name']} ${userData!['last_name']}"),
                            ],
                           ),
                         ),
                         Divider(height: 1,color: const Color.fromARGB(255, 172, 166, 166),),
                          Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text("Email"),
                                Text(userData!['email']),
                            ],
                           ),
                         ),

                          Divider(height: 1,color: const Color.fromARGB(255, 172, 166, 166),),
                          Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text("Phone No"),
                                Text(userData!['phone_number'] ?? "000000000"),
                            ],
                           ),
                         ),


                          Divider(height: 1,color: const Color.fromARGB(255, 172, 166, 166),),
                          Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text("Bank Acc.No"),
                                Text(userData!['bank_account'] ?? "000000000"),
                            ],
                           ),
                         ),


                          Divider(height: 1,color: const Color.fromARGB(255, 172, 166, 166),),
                          Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text("Pancard No"),
                                Text(userData!['pancard'] ?? "000000000"),
                            ],
                           ),
                         ),

                          Divider(height: 1,color: const Color.fromARGB(255, 172, 166, 166),),
                          Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text("Balance"),
                                Text(userData!['balance'] ?? "000000000"),
                            ],
                           ),
                         )
                
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
