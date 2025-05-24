import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String name;
  VoidCallback onPressed;
  final Color color;
  final double width;
  MyButton({
    super.key,
    required this.name,
    required this.onPressed,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: MaterialButton(
      
        padding: EdgeInsets.only(top: 10, bottom: 10),
        minWidth: width,
        color: color,
        onPressed: onPressed,
        child: Text(name),
        
      ),
    );
  }
}