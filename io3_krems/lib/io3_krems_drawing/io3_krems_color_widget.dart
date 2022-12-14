import 'package:flutter/material.dart';

class IO3KremsColorWidget extends StatefulWidget {
  final bool isSelected;
  final Color color;
  final Color checkColor;

  const IO3KremsColorWidget(
      {Key? key,
      required this.isSelected,
      required this.color,
      required this.checkColor})
      : super(key: key);

  @override
  _IO3KremsColorWidgetState createState() => _IO3KremsColorWidgetState();
}

class _IO3KremsColorWidgetState extends State<IO3KremsColorWidget>
    with TickerProviderStateMixin {
  late AnimationController animController = AnimationController(
      duration: const Duration(milliseconds: 400), vsync: this);

  @override
  void initState() {
    super.initState();
    animController.forward();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: widget.color,
      child: widget.isSelected
          ? SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: animController,
                curve: Curves.linear,
              ),
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: Center(
                child: Icon(
                  Icons.check_rounded,
                  color: widget.checkColor,
                ),
              ),
            )
          : Container(),
    );
  }
}
