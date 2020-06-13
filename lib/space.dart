import 'package:flutter/material.dart';

class WhiteSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
        height: size.height/2 - size.width/2,
        width: size.width,
    );
  }
}