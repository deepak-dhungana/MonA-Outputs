import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:io3_krems/io3_krems_config.dart';
import 'package:io3_krems/screen_info.dart';
import 'dart:html' as html;

import 'dart:ui' as ui;

import '../colors.dart';
import 'bubble.dart';

class TextBubble extends StatefulWidget {
  final String backgroundImagePath;

  const TextBubble({Key? key, required this.backgroundImagePath})
      : super(key: key);

  @override
  _TextBubbleState createState() => _TextBubbleState();
}

class _TextBubbleState extends State<TextBubble> {
  late final List<Widget> _widgetList = [];

  Color _undoButtonColor = Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  // key for the drawing board
  final GlobalKey _drawingBoardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
        mediaQueryData: MediaQuery.of(context));

    final screenSize = screenInfo.entireScreenSize;

    return Material(
      child: Stack(
        children: [
          RepaintBoundary(
            key: _drawingBoardKey,
            child: Stack(
              children: <Widget>[
                LayoutBuilder(
                  builder: (lbContext, lbConstraints) {
                    return Image.network(
                      widget.backgroundImagePath,
                      fit: BoxFit.cover,
                      width: lbConstraints.maxWidth,
                      height: lbConstraints.maxHeight,
                    );
                  },
                ),
                Stack(
                  children: _widgetList,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: screenInfo.bottomPadding + 30,
            right: screenInfo.rightPadding + 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        if (_widgetList.isNotEmpty) {
                          setState(() {
                            _widgetList.removeLast();
                          });
                        }

                        if (_widgetList.isEmpty) {
                          setState(() {
                            _undoButtonColor = Colors.grey;
                          });
                        }
                      },
                      child: const Icon(
                        Icons.undo,
                        color: Colors.black,
                      ),
                      backgroundColor: _undoButtonColor,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        downloadKarikatur(imageBytes: await capturePNG());
                      },
                      child: const Icon(
                        Icons.file_download,
                        color: Colors.white,
                      ),
                      backgroundColor: MonAColors.darkGreen,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    html.window.location.replace(IO3KremsConfig.afterBubbleURL);
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
          Positioned(
            bottom: screenInfo.bottomPadding + 30,
            left: screenInfo.rightPadding + 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    addSpeechBubble(
                        screenSize.width / 2, screenSize.height / 2);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Sprechblase",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "cera-gr-medium",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: MonAColors.darkMagenta,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    addThinkingBubble(
                        screenSize.width / 2, screenSize.height / 2);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Gedankenblase",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "cera-gr-medium",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: MonAColors.darkMagenta,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addSpeechBubble(double centerX, double centerY) {
    setState(() {
      _undoButtonColor = MonAColors.darkWarmRed;

      _widgetList.add(
        Bubble(
          key: GlobalKey(),
          centerX: centerX,
          centerY: centerY,
          type: BubbleType.speechBubble,
        ),
      );
    });
  }

  void addThinkingBubble(double centerX, double centerY) {
    setState(() {
      _undoButtonColor = MonAColors.darkWarmRed;

      _widgetList.add(
        Bubble(
          key: GlobalKey(),
          centerX: centerX,
          centerY: centerY,
          type: BubbleType.thinkingBubble,
        ),
      );
    });
  }

  Future<void> downloadKarikatur(
      {required String imageBytes, String fileName = "Karikatur.png"}) async {
    final imageElement = html.document.createElement('img') as html.ImageElement
      ..src = imageBytes;

    final anchorElement = html.document.createElement('a') as html.AnchorElement
      ..href = imageElement.src
      ..style.display = 'none'
      ..download = fileName;

    html.document.body!.children.add(anchorElement);

    anchorElement.click();
  }

  /// Method for capturing the screen pixels in PNG format
  Future<String> capturePNG() async {
    try {
      RenderRepaintBoundary boundary = _drawingBoardKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 2.0);

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      var pngBytes = byteData!.buffer.asUint8List();

      const String pngHeader = "data:image/png;base64,";

      return pngHeader + base64Encode(pngBytes);
    } catch (e) {
      throw Exception("Could not read display pixel data!!!");
    }
  }
}
