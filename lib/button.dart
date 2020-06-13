import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  @override

  Function onTap;

  CameraButton(this.onTap);
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
        right: size.width / 2 - 25,
        bottom: 60,
        child: GestureDetector(
            onTap: onTap,
            child: Container(
                child: Opacity(opacity: 1),
                width: 50,
                height: 50,
                decoration: ShapeDecoration(
                    shape: new CircleBorder(
                        side: new BorderSide(
                            width: 10.0, color: Colors.black))))));
  }

}
