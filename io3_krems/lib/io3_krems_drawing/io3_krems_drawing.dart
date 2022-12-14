import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:io3_krems/colors.dart';
import 'package:p5/p5.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../screen_info.dart';
import '../io3_krems_config.dart';
import './io3_krems_color_widget.dart';

part 'io3_krems_sketch.dart';

/*

  VERY IMPORTANT:

  repaintBoundary.toImage method works only with canvaskit renderer. Not yet
  implemented for HTML

  Build command:
  flutter build web --release --no-sound-null-safety --web-renderer canvaskit

 */

class IO3KremsDrawing extends StatefulWidget {
  const IO3KremsDrawing({Key? key}) : super(key: key);

  @override
  _IO3KremsDrawingState createState() => _IO3KremsDrawingState();
}

class _IO3KremsDrawingState extends State<IO3KremsDrawing>
    with SingleTickerProviderStateMixin {
  // initialization of the sketch board
  final IO3KremsSketch sketch = IO3KremsSketch();

  // declaration of the animator object
  late final PAnimator animator;

  // key for the drawing board
  final GlobalKey _drawingBoardKey = GlobalKey();

  // setting black as default selected color
  static Color userSelectedColor = const Color(0xFF000000);

  static double userSelectedStrokeWidth = 10.0;

  // list of colors for drawing
  final List<Color> _drawingColors = [
    const Color(0xFF000000),
    const Color(0xFFFF0000),
    const Color(0xFF0000FF),
    const Color(0xFFF3C500),
    const Color(0xFF00634F),
    const Color(0xFFC40079),
    const Color(0xFF732A83),
    const Color(0xFFF37E89)
  ];

  final List<Color> _checkColors = [
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFF000000),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFF000000),
  ];

  // button selection for the number of drawing colors
  late List<bool> _toggleButtonSelections = List.generate(
      _drawingColors.length, (index) => index == 0 ? true : false);

  // eraser border color
  Color _eraserBorderColor = MonAColors.darkYellow;

  @override
  void initState() {
    super.initState();

    animator = PAnimator(this);

    animator.addListener(() {
      if (mounted) {
        setState(() {
          sketch.redraw();
        });
      }
    });

    animator.run();
  }

  @override
  void dispose() {
    sketch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = ScreenInformation.fromMediaQueryData(
        mediaQueryData: MediaQuery.of(context));
    return Stack(
      children: [
        RepaintBoundary(
          key: _drawingBoardKey,
          child: PWidget(sketch),
        ),
        Positioned(
          bottom: screenInfo.bottomPadding + 10,
          right: screenInfo.rightPadding + 10,
          child: FloatingActionButton.extended(
            onPressed: () {
              _nextStep();
            },
            label: const Text("Nächster Schritt"),
          ),
        ),
        _buildResponsiveToggleButtons(screenInfo),
        _buildResponsiveEraserButton(screenInfo),
      ],
    );
  }

  /// Builds Toggle buttons based on orientation
  Widget _buildResponsiveToggleButtons(ScreenInformation screenInformation) {
    final Orientation orientation = screenInformation.screenOrientation;

    if (orientation == Orientation.portrait) {
      return Positioned(
        top: screenInformation.topPadding + 10,
        left: screenInformation.leftPadding,
        right: 0,
        child: _buildToggleButtons(Axis.horizontal),
      );
    }

    return Positioned(
      top: screenInformation.topPadding,
      bottom: 0,
      left: screenInformation.leftPadding + 10,
      child: _buildToggleButtons(Axis.vertical),
    );
  }

  /// Builds Toggle buttons
  Widget _buildToggleButtons(Axis direction) {
    return SingleChildScrollView(
      scrollDirection: direction,
      child: ToggleButtons(
        direction: direction,
        children: List.generate(_drawingColors.length, (index) {
          return IO3KremsColorWidget(
            isSelected: _toggleButtonSelections[index],
            color: _drawingColors[index],
            checkColor: _checkColors[index],
          );
        }),
        isSelected: _toggleButtonSelections,
        onPressed: (int idx) {
          setState(() {
            // assign eraser border color
            _eraserBorderColor = MonAColors.darkYellow;

            userSelectedStrokeWidth = 10.0;

            // assign the selected color
            userSelectedColor = _drawingColors[idx];

            _toggleButtonSelections = List.generate(_drawingColors.length,
                (itemIndex) => idx == itemIndex ? true : false);
          });
        },
        borderWidth: 5.0,
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        fillColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
    );
  }

  /// Builds eraser button based on orientation
  Widget _buildResponsiveEraserButton(ScreenInformation screenInformation) {
    final Orientation orientation = screenInformation.screenOrientation;
    if (orientation == Orientation.portrait) {
      return Positioned(
        bottom: screenInformation.bottomPadding + 10,
        left: screenInformation.rightPadding + 10,
        child: _buildEraserButton(),
      );
    }

    return Positioned(
      top: screenInformation.bottomPadding + 10,
      right: screenInformation.rightPadding + 10,
      child: _buildEraserButton(),
    );
  }

  /// Builds Eraser button
  Widget _buildEraserButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: MonAColors.darkYellow,
        elevation: 8.0,
        side: BorderSide(width: 2.5, color: _eraserBorderColor),
      ),
      onPressed: () {
        setState(() {
          _eraserBorderColor = Colors.black;

          // assign the selected color
          userSelectedColor = const Color(0xFFFFFFFF);

          userSelectedStrokeWidth = 15.0;

          _toggleButtonSelections =
              List.generate(_drawingColors.length, (_) => false);
        });
      },
      child: Image.asset(
        "assets/images/eraser.png",
        width: 32,
        height: 32,
      ),
    );
  }

  // ################################## NON - UI ###############################

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

  /// triggers the next step after drawing
  void _nextStep() async {
    html.window.localStorage["karikatur"] = await capturePNG();

    html.window.location.replace(IO3KremsConfig.afterDrawingURL);
  }
}
