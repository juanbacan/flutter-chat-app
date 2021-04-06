import 'package:flutter/material.dart';

class Btn_Azul extends StatelessWidget {

  final String text;
  final Function onPressed;

  const Btn_Azul({
    Key key, 
    @required this.text, 
    @required this.onPressed
  }) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        primary: Colors.blue,
        shape: StadiumBorder(),
      ),
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(this.text, style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
      ),
      
    );
  }
}