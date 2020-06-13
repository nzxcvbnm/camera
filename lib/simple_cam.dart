import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'package:simple_camera/button.dart';
import 'package:simple_camera/space.dart';

class MyApp extends StatefulWidget {
  final CameraDescription camera;

  const MyApp({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void takePic() async {
    try {
      await _initializeControllerFuture;
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      await _controller.takePicture(path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakenPicture(imagePath: path),
        ),
      );
      GallerySaver.saveImage(path);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(children: <Widget>[
              CameraPreview(_controller),
              Column(children: <Widget>[
                WhiteSpace(),
                SizedBox(height: MediaQuery.of(context).size.width),
                WhiteSpace(),
              ]),
              CameraButton(takePic),
            ]);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class TakenPicture extends StatelessWidget {
  final String imagePath;

  const TakenPicture({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Image.file(File(imagePath)),
    );
  }
}
