import 'package:flutter/material.dart';


const Color lightGreen = Color(0xFF95E08E);
const Color lightBlueIsh = Color(0xFF33BBB5);
const Color darkGreen = Color(0xFF00AA12);
const Color backgroundColor = Color(0xFFEFEEF5);


const TextStyle titleStyleWhite = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25
);

const TextStyle titleStyleLighterBlack = TextStyle(
    color: Color(0xFF34475D),
    fontWeight: FontWeight.bold,
    fontSize: 20
);



const double baseHeight = 825;
double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery
      .of(context)
      .size
      .height / baseHeight;
}