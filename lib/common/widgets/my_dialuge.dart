import 'package:flutter/material.dart';
import 'package:trade_app/common/widgets/text_field.dart';

class MyDialuge extends StatelessWidget {
  final String lable1;
  final String lable2;
  final String lable3;
  final String lable4;
  final lable1Controller;
  final lable2Controller;
  final lable3Controller;
  final lable4Controller;
  final FormFieldValidator lable1Validator;
  final FormFieldValidator lable2Validator;
  final FormFieldValidator lable3Validator;
  final FormFieldValidator lable4Validator;
  final Function onSubmit;
  const  MyDialuge({
    super.key,
    required this.lable1 ,
    required this.lable2 ,
    required this.lable3 ,
    required this.lable4 ,
    required this.lable1Controller,
    required this.lable2Controller,
    required this.lable3Controller,
    required this.lable4Controller,
    required this.lable1Validator,
    required this.lable2Validator,
    required this.lable3Validator,
    required this.lable4Validator,
    required this.onSubmit,
  });
  

  @override
  Widget build(BuildContext context) {
    
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return AlertDialog(
      // 4 input fields
      title: const Text('Enter Details'),
      content: SingleChildScrollView(
        child: Form(
          key:_formKey ,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextFeild(
                controller: lable1Controller, 
                lable: lable1, 
                readOnly: false,
                validator: lable1Validator,
              ),
              MyTextFeild(
                controller: lable2Controller, 
                lable: lable2, 
                readOnly: false,
                validator: lable2Validator
              ),

              MyTextFeild(
                controller: lable3Controller, 
                lable: lable3, 
                readOnly: false,
                validator:lable3Validator
              ),
              MyTextFeild(
                controller: lable4Controller, 
                lable: lable4, 
                readOnly: false,
                validator: lable4Validator
              ),
            ],
          ),
        ),
      ),actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              
              onSubmit();
              Navigator.of(context).pop();
           
            }else {
              // If the form is not valid, show a snackbar or some other feedback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all fields correctly')),
              );
            }
            
            //how i get the value of the text field

          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}