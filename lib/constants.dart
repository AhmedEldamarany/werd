import 'package:flutter/material.dart';

const List<Color> KmyColors = [
  Color(0xFF012d4a),
  Color(0xFF014753),
  Color(0xFF016392),
  Color(0xFF01839d),
  Color(0xFFaacfe2),
  Color(0xFFd7dcde),
];

//Todo needs a controller
class CustomeTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscure;
  final TextInputType keyboardType;
  final Function onSaved;

  CustomeTextField({
    this.onSaved,
    this.keyboardType,
    this.labelText,
    this.hintText,
    this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 5, right: 3),
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.emailAddress,
        //style: TextStyle(fontSize: 18),
        obscureText: obscure ?? false,
        onSaved: onSaved,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(color: KmyColors[3], width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(color: KmyColors[3], width: 1),
          ),
        ),
      ),
    );
  }
}
