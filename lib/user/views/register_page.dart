import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:trade_app/common/widgets/dropdown.dart';
import 'package:trade_app/common/widgets/my_button.dart';
import 'package:trade_app/common/widgets/text_field.dart';
import 'package:trade_app/service/service.dart';
// import 'package:shared_preferences_android/shared_preferences_android.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final AppService _appService = AppService();
  late Future<List<Map<String, dynamic>>> bankDetails;
  String client_Id = '';
  late int? selectedBankId;
  String? selectedIfscCode = '';

 
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController panCardContoller = TextEditingController();
  final TextEditingController nomineeController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();

  


  @override
  void initState() {
    super.initState();
    bankDetails = _appService.getBankDetails();
    print(bankDetails);
  }

  void FormSubmit() async{
    if(_formKey.currentState!.validate()){

        
       
         Map<String, dynamic> userInfo = 
        {
          "first_name": firstNameController.text, 
          "last_name": lastNameController.text,
          "email": emailController.text, 
          "phone_number": phoneNumberController.text, 
          "pancard": panCardContoller.text, 
          "nominee_name": nomineeController.text, 
          "bank_id": selectedBankId, 
          "bank_account": accountNumberController.text, 
          "password": passwordController.text,
          "balance": balanceController.text
        };

        
    try {
      var responseData = await _appService.createUser(userInfo);
      Navigator.pushNamed(context, "/login", arguments: responseData);
    } catch (e) {
      // handle error, maybe show Snackbar or dialog
      print('Registration failed: $e');
    }  

                // SharedPreferences preferences = await SharedPreferences.getInstance();
                // await preferences.setString("client_Id", client_Id);

                
                 

    


    }
  }
  
 
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color.fromARGB(255, 223, 224, 226),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 30, left: 20, right: 20),
          child: Container(
            width: 300,
            color: const Color.fromARGB(43, 48, 95, 97),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey, // Add form key for validation
                child: ListView(
                  children: [
                    // First Name Field with validation
                    MyTextFeild(
                      controller: firstNameController,
                      lable: "First Name",
                      readOnly: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    // Last Name Field with validation
                    MyTextFeild(
                      controller: lastNameController,
                      lable: "Last Name",
                      readOnly: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    // Email Field 
                    MyTextFeild(
                      controller: emailController,
                      lable: "Email Address",
                      readOnly: false,
                      
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Email Feild
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    // Phone Number Field
                    MyTextFeild(
                      controller: phoneNumberController,
                      lable: "Contact Number",
                      readOnly: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        }
                        if (!RegExp(r'^\+?[0-9]{10,13}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    // Pan Card Field
                    MyTextFeild(
                      controller: panCardContoller,
                      lable: "Pan Card Number",
                      readOnly: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Pan Card number';
                        }
                        return null;
                      },
                    ),
                    // Nominee Name Field 
                    MyTextFeild(
                      controller: nomineeController,
                      lable: "Nominee Name",
                      readOnly: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter nominee name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    // Bank Dropdown
                    MyDropDown(
                      controller: bankController,
                      lable: "Select Bank",
                      item: bankDetails,
                      onBankSelected: (bankId, ifscCode) {
                        setState(() {
                          selectedBankId = int.parse(bankId);
                          selectedIfscCode = ifscCode;
                          ifscController.text = ifscCode;
                        });
                      },
                    ),
                    // IFSC Code (Read-only)
                    MyTextFeild(
                      controller: ifscController,
                      lable: "IFSC Code",
                      readOnly: true,
                    ),
                    // Account Number 
                    MyTextFeild(
                      controller: accountNumberController,
                      lable: "Account Number",
                      readOnly: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        return null;
                      },
                    ),
                    // Password Field 
                    MyTextFeild(
                      controller: passwordController,
                      lable: "Password",
                      readOnly: false,
                      
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    // Account Balance 
                    MyTextFeild(
                      controller: balanceController,
                      lable: "Account Balance",
                      readOnly: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account balance';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    // Register Button
                    MyButton(
                      name: "Register",
                      onPressed: (){
                        print(firstNameController.text);
                        if (_formKey.currentState!.validate()) {
                          FormSubmit();
                        }
                        
                      },
                      color: Colors.green,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
