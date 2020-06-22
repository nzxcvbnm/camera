import 'package:flutter/material.dart';
import 'dart:io';

class Picture extends StatelessWidget {
  final File image;

  const Picture({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Image.file(image),
      ),
    );
  }
}