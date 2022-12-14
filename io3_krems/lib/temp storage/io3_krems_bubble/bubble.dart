import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';

/// Types of bubble for Krems IO3  game
enum BubbleType { speechBubble, thinkingBubble }

class Bubble extends StatefulWidget {
  // center of the screen
  final double centerX;
  final double centerY;

  // type of bubble. Either 'speech' or 'thinking'.
  final BubbleType type;

  // selected bubble background image location
  final String backgroundImagePath;

  const Bubble(
      {Key? key,
      required this.centerX,
      required this.centerY,
      required this.type})
      : backgroundImagePath = "assets/text_bubbles/"
            "${type == BubbleType.speechBubble ? "speech_bubble.png" : "thinking_bubble.png"}",
        super(key: key);

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  // TODO: change for tablets
  double containerHeight = 150.0;
  double containerWidth = 200.0;

  // position of the bubble
  late double _positionX;
  late double _positionY;

  bool _buttonsVisible = false;

  final TextEditingController _textBubbleEditingController =
      TextEditingController();

  double _scale = 1.0;
  double _initialScale = 1.0;

  double _textSize = 16;
  final double _baseTextSize =
      18; // since, the text size will be increased or decreased by 2

  @override
  void initState() {
    super.initState();

    // initial position in the center of the screen
    _positionX = widget.centerX - (containerWidth / 2);
    _positionY = widget.centerY - (containerHeight / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: _positionX,
        top: _positionY,
        child: XGestureDetector(
          onMoveUpdate: (details) {
            setState(() {
              _positionX += details.delta.dx;
              _positionY += details.delta.dy;
            });
          },
          onScaleStart: (details) {
            _initialScale = _scale;
          },
          onScaleUpdate: (details) {
            setState(() {
              _scale = _initialScale * details.scale;
            });
          },
          onDoubleTap: (tapEvent) {
            setState(() {
              _buttonsVisible = !_buttonsVisible;
            });
          },
          child: Row(
            children: [
              Transform.scale(
                scale: _scale,
                child: Container(
                  width: containerWidth,
                  height: containerHeight,
                  padding: EdgeInsets.symmetric(
                    horizontal: containerWidth / 10,
                    vertical: containerHeight / 4,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: Image.asset(widget.backgroundImagePath).image),
                  ),
                  child: Center(
                    child: TextField(
                      autofocus: false,
                      controller: _textBubbleEditingController,
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Hier schreiben...",
                      ),
                      style: TextStyle(
                        fontFamily: "cera-gr-medium",
                        fontSize: _textSize,
                      ),
                    ),
                  ),
                ),
              ),
              _buttonsVisible ? _buttonsBuilder() : Container(),
            ],
          ),
        ));
  }

  Widget _buttonsBuilder() {
    return Column(
      children: [
        SizedBox(
          height: 24.0,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _textSize += 2;
              });
            },
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 24.0,
          child: FloatingActionButton(
            onPressed: () {
              if (_textSize >= _baseTextSize) {
                setState(() {
                  _textSize -= 2;
                });
              }
            },
            child: const Icon(
              Icons.remove,
            ),
          ),
        ),
      ],
    );
  }
}
