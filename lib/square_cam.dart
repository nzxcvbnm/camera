import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:camera/camera.dart';

import 'button.dart';
import 'space.dart';
import 'taken_picture.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<HomePage> {
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
      cropImage(path);
    } catch (e) {
      print(e);
    }
  }

  Future cropImage(String path) async {
    File image = await ImageCropper.cropImage(
        sourcePath: path,
        androidUiSettings: AndroidUiSettings(
            backgroundColor: Colors.white,
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
      );
      if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Picture(image: image),
        ),
      );
      GallerySaver.saveImage(image.path);
  }
}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
      return Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(children: <Widget>[
                Container(
                  width: size.width,
                  height: size.height * 0.8,
                  child: CameraPreview(_controller),
                ),
                Column(children: <Widget>[
                  WhiteSpace(),
                  SizedBox(height: size.width),
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

