import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io3_krems/io3_krems_config.dart';
import 'package:io3_krems/mona_web_camera.dart';

import '../colors.dart';
import '../screen_info.dart';

class IO3KremsPicture extends StatefulWidget {
  const IO3KremsPicture({Key? key}) : super(key: key);

  @override
  _IO3KremsPictureState createState() => _IO3KremsPictureState();
}

class _IO3KremsPictureState extends State<IO3KremsPicture> {
  // initializing camera service for image capturing task
  final MonAWebCameraService cameraService =
      MonAWebCameraService(task: CameraTasks.captureImage);

  // Camera preview Widget
  late final Widget cameraPreviewWidget;

  // captured image
  late MonAImageFile monaImageFile;

  // for state management
  bool _cameraInitialized = false;
  bool _errorTakingPicture = false;
  bool _pictureTaken = false;
  bool _isTakingPicture = false;

  void _resetStates() {
    html.window.location.replace("");
  }

  @override
  void initState() {
    // call the camera initializer
    _initializeCamera();

    super.initState();
  }

  @override
  void dispose() {
    // close the camera
    _closeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = ScreenInformation.fromMediaQueryData(
        mediaQueryData: MediaQuery.of(context));

    final screenSize = screenInfo.entireScreenSize;

    if (_errorTakingPicture) {
      return _buildErrorView(screenSize);
    }

    if (!_cameraInitialized) {
      return _buildInProgressView();
    }

    if (_cameraInitialized && !_pictureTaken) {
      return _buildCameraPreview(screenSize);
    }

    if (_cameraInitialized && _pictureTaken) {
      return _buildImageView(screenInfo);
    }

    // default view would be error, then
    return _buildErrorView(screenSize);
  }

  Widget _buildInProgressView() {
    return Center(
      child: Transform.scale(
        scale: 2,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildCameraPreview(Size screenSize) {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Fetching camera stream...",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: screenSize.width * 0.25,
                child: const LinearProgressIndicator(),
              )
            ],
          ),
        ),
        cameraPreviewWidget,
        Positioned(
          bottom: 0,
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height * 0.20,
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: MonAColors.darkYellow,
                  elevation: 10.0,
                  padding: EdgeInsets.all(screenSize.height * 0.05),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  // kaching :)
                  _takePicture();
                },
                child: _buildButtonBody(screenSize),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageView(ScreenInformation screenInfo) {
    Size screenSize = screenInfo.entireScreenSize;

    return Stack(
      children: <Widget>[
        Image.network(
          monaImageFile.imageBlobURL,
          width: screenSize.width,
          height: screenSize.height,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: screenInfo.bottomPadding + 30,
          right: screenInfo.rightPadding + 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  _resetStates();
                },
                icon: const Icon(
                  Icons.repeat_rounded,
                  color: Colors.white,
                ),
                label: const Text(
                  "Erneut versuchen",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "cera-gr-medium",
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  // download the file
                  cameraService.downloadFile(
                      blobURL: monaImageFile.imageBlobURL,
                      fileName: monaImageFile.fileName);
                },
                icon: const Icon(
                  Icons.file_download,
                  color: Colors.white,
                ),
                label: const Text(
                  "Foto herunterladen",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "cera-gr-medium",
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  html.window.location.replace(IO3KremsConfig.afterPictureURL);
                },
                label: const Text(
                  "Nächster Schritt",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "cera-gr-medium",
                  ),
                ),
                backgroundColor: MonAColors.darkYellow,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(Size screenSize) {
    return Center(
      child: Container(
        color: MonAColors.darkYellow,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/sad_face.png",
                height: screenSize.height * 0.2,
              ),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  "Berechtigung verweigert oder ein unbekannter Fehler ist aufgetreten",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "cera-gr-medium",
                      fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  _resetStates();
                },
                backgroundColor: Colors.black,
                label: const Text(
                  "Nochmal versuchen",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "cera-gr-medium",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonBody(Size screenSize) {
    if (_isTakingPicture) {
      return CupertinoTheme(
        data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
        child: CupertinoActivityIndicator(
          radius: screenSize.height * 0.025,
        ),
      );
    }

    return Text(
      "Foto\nmachen",
      style: TextStyle(
          fontSize: screenSize.height * 0.025,
          color: Colors.black,
          fontFamily: "cera-gr-bold"),
      textAlign: TextAlign.center,
    );
  }

  // ############################### NON-UI ##################################

  void _initializeCamera() async {
    try {
      // first initialize
      await cameraService.initializeCamera();

      // assign the camera preview widget
      cameraPreviewWidget = await cameraService.createCameraPreview();

      // update the state
      setState(() {
        _cameraInitialized = true;
      });

      // to solve IOS loading issue
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {});
      });
    } catch (e) {
      setState(() {
        _errorTakingPicture = true;
      });
    }
  }

  void _closeCamera() async {
    try {
      await cameraService.closeCamera();
    } catch (e) {
      // do nothing
    }
  }

  void _takePicture() async {
    try {
      setState(() {
        _isTakingPicture = true;
      });

      monaImageFile = await cameraService.takePicture();

      setState(() {
        _isTakingPicture = false;
        _pictureTaken = true;
      });
    } catch (e) {
      setState(() {
        _errorTakingPicture = true;
      });
    }
  }
}
