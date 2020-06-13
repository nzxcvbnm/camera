import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'simple_cam.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

  runApp(
    MaterialApp(
      home: MyApp(camera: firstCamera)
    )
  );
}
