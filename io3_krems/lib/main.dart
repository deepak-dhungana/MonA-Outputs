import 'package:flutter/material.dart';

import 'package:io3_krems/colors.dart';

// import 'io3_krems_video/video_page.dart';
// import 'io3_krems_picture/io3_krems_picture.dart';
import 'io3_krems_drawing/io3_krems_drawing.dart';
// import 'io3_krems_bubble/io3_krems_text_bubble.dart';

// import 'io3_nemo_picture/io3_nemo_picture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "cera-gr-regular",
        primarySwatch: monaMaterialMagenta,
      ),
      home: const Material(
        child: IO3KremsDrawing(),
      ),
    );
  }
}