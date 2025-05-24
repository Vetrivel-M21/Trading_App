import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trade_app/common/widgets/my_button.dart';
import 'package:trade_app/service/service.dart';
import 'widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  late String? pageRoute;

  final AppService _appService = AppService();

  final _loginkey = GlobalKey<FormState>();

  void verifyUser(){
    if(_loginkey.currentState!.validate()){
      final String aboutUser = nameController.text.substring(0, 2);
      Map<String, String> userMap = {
          'FT' : "user",
          'AD' : "admin",
          'BO' : "backofficer",
          'BI' : "biller",
          'AP' : "approver"

      };
       pageRoute  = userMap[aboutUser].toString();

    }
  }

  

  void LoginFun(){
    if(_loginkey.currentState!.validate()){
        Map<String, dynamic> loginData = {
              "client_id": nameController.text, 
              "password": passController.text
        };

       if(pageRoute == 'user'){
          _appService.logIn(loginData).then((response)async{
              if(response.statusCode==200){
                  final decodedResponse = jsonDecode(response.body);
                   if (decodedResponse is Map<String, dynamic> && decodedResponse['resp'] is Map) {
                      var userMap = decodedResponse['resp'] as Map;
                      final Map<dynamic, dynamic> UserInfomation = userMap;
                      print(UserInfomation);

                      Navigator.pushNamed(context, "/$pageRoute", arguments: UserInfomation);
                   }
              }
          });
       }
       else if(pageRoute == 'admin'){
          _appService.logIn(loginData).then((response)async{

          });
       }
       else if(pageRoute == 'backofficer'){
          _appService.logIn(loginData).then((response)async{

          });
       }
       else if(pageRoute == 'biller'){
          _appService.logIn(loginData).then((response)async{

          });
       }
       else {
          _appService.logIn(loginData).then((response)async{

          });
       }
       
       
    }

  }
   
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? client_id = args != null ? args['client_id'] as String? : null;
    return Scaffold(
      
        body: Center(
          child: Container(
            padding: EdgeInsets.only(top: 30, bottom: 20, left: 10, right: 10),
            decoration: BoxDecoration(
              
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(30)

            ),
                  height: 400,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      key: _loginkey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if(client_id != null)
                                Text(client_id, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),),
                            SizedBox(height: 10,),
                            // CircleAvatar(),
                            MyTextFeild(
                              lable: "Enter ID",
                              controller: nameController,
                              readOnly: false,
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return "Please enter the  ID";
                                }
                                return null;
                              },
                            ),
                      
                            const SizedBox(height: 20,),
                      
                            MyTextFeild(
                              lable: "Password",
                              controller: passController,
                              readOnly: false,
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return "please enter the password";
                                }
                                return null;
                              },
                            ),
                      
                             const SizedBox(height: 20,),
                      
                            //button
                            MyButton(name: "Login", onPressed: (){
                              verifyUser();
                              LoginFun();

                            }, color: Colors.lightGreen, width: double.infinity,),
                            
                             const SizedBox(height: 20,),
                      
                            MyButton(name: "Create Account", onPressed: ()=>Navigator.pushNamed(context, "/register"), color: Colors.white, width:double.infinity,)
                            //signup link
                          ],
                      ),
                    ),
                  ),
              ),
        ),
          
       
    );
  }
}