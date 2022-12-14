import 'package:flutter/material.dart';

/// Tested with size = 60.0
class MonASuccessAnimation extends StatefulWidget {
  final double size;

  const MonASuccessAnimation({Key? key, required this.size}) : super(key: key);

  @override
  _MonASuccessAnimationState createState() => _MonASuccessAnimationState();
}

class _MonASuccessAnimationState extends State<MonASuccessAnimation>
    with TickerProviderStateMixin {
  // Scale animation
  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );

  late final Animation _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.elasticOut,
  );

  // Check mark animation
  late final AnimationController _checkAnimController = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  late final Animation _checkMarkAnimation = CurvedAnimation(
    parent: _checkAnimController,
    curve: Curves.linear,
  );

  // Defined sizes of the circle and the check mark
  late final double _circleSize = widget.size;
  late final double _checkMarkSize = widget.size;

  @override
  void initState() {
    super.initState();

    _scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkAnimController.forward();
      }
    });
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _checkAnimController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation as Animation<double>,
            child: CircleAvatar(
              radius: _circleSize,
              backgroundColor: Colors.green,
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _checkMarkAnimation as Animation<double>,
          axis: Axis.horizontal,
          axisAlignment: -1,
          child: Center(
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: _checkMarkSize,
            ),
          ),
        ),
      ],
    );
  }
}
