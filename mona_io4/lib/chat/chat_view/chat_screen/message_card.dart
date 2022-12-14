import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../chat_logic/chat_model.dart';
import 'package:mona/responsive_and_adaptive/screen_info.dart';

const double messageCardElevation = 2.0;
const double messageCardMinWidth = 130;
const double messageCardMinWidthWithName = 175;

/// IF the message is sent the by the user.
/// Extra padding if the previous message is not sent by the user.
class MessageCardType1 extends StatefulWidget {
  final Message message;
  final bool extraTopPadding;

  const MessageCardType1(
      {Key? key, required this.message, this.extraTopPadding = false})
      : super(key: key);

  @override
  _MessageCardType1State createState() => _MessageCardType1State();
}

class _MessageCardType1State extends State<MessageCardType1> {
  @override
  Widget build(BuildContext context) {
    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
        mediaQueryData: MediaQuery.of(context));

    final Size screenSize = screenInfo.entireScreenSize;

    final double fontWeight = screenInfo.screenType == ScreenType.mobilePortrait ||
        screenInfo.screenType == ScreenType.mobileLandscape
        ? 0
        : 2;

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.70, minWidth: messageCardMinWidth),
        child: Card(
          margin: EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: widget.extraTopPadding ? 20.0 : 5.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: MonAColors.darkMagenta,
          elevation: messageCardElevation,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 30.0,
                  top: 10.0,
                  bottom: 20.0 + fontWeight * 2,
                ),
                child: Text(
                  widget.message.message,
                  style: TextStyle(
                    fontSize: 16 + fontWeight * 2,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 5.0,
                right: 5.0,
                child: Text(
                  _getTime(widget.message.time),
                  style: TextStyle(
                    fontSize: 12 + fontWeight,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _getTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, "0")}"
        ":${dateTime.minute.toString().padLeft(2, "0")}";
  }
}

// ############################################################################
// ############################################################################
// ############################################################################

/// Sent by others with name
class MessageCardType2 extends StatefulWidget {
  final Message message;

  const MessageCardType2({Key? key, required this.message}) : super(key: key);

  @override
  _MessageCardType2State createState() => _MessageCardType2State();
}

class _MessageCardType2State extends State<MessageCardType2> {
  @override
  Widget build(BuildContext context) {
    final ScreenInformation screenInfo =
        ScreenInformation.fromMediaQueryData(
            mediaQueryData: MediaQuery.of(context));

    final Size screenSize = screenInfo.entireScreenSize;

    final double fontWeight = screenInfo.screenType == ScreenType.mobilePortrait ||
        screenInfo.screenType == ScreenType.mobileLandscape
        ? 0
        : 2;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenSize.width * 0.70,
          minWidth: messageCardMinWidthWithName,
        ),
        child: Card(
          margin: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 20.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: MonAColors.darkYellow,
          elevation: 1.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 5.0,
                left: 10.0,
                child: Text(
                  widget.message.senderName,
                  style: TextStyle(
                    fontSize: 12 + fontWeight,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 30.0,
                  top: 25.0 + fontWeight * 2,
                  bottom: 20.0 + fontWeight * 2,
                ),
                child: Text(
                  widget.message.message,
                  style: TextStyle(
                    fontSize: 16 + fontWeight * 2,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 5.0,
                right: 5.0,
                child: Text(
                  _getTime(widget.message.time),
                  style: TextStyle(
                    fontSize: 12 + fontWeight,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _getTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, "0")}"
        ":${dateTime.minute.toString().padLeft(2, "0")}";
  }
}
// ############################################################################
// ############################################################################
// ############################################################################

/// Sent by others without name
class MessageCardType3 extends StatefulWidget {
  final Message message;

  const MessageCardType3({Key? key, required this.message}) : super(key: key);

  @override
  _MessageCardType3State createState() => _MessageCardType3State();
}

class _MessageCardType3State extends State<MessageCardType3> {
  @override
  Widget build(BuildContext context) {
    final ScreenInformation screenInfo =
        ScreenInformation.fromMediaQueryData(
            mediaQueryData: MediaQuery.of(context));

    final Size screenSize = screenInfo.entireScreenSize;

    final double fontWeight = screenInfo.screenType == ScreenType.mobilePortrait ||
        screenInfo.screenType == ScreenType.mobileLandscape
        ? 0
        : 2;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenSize.width * 0.70,
          minWidth: messageCardMinWidth,
        ),
        child: Card(
          margin: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 5.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: MonAColors.darkYellow,
          elevation: 1.0,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 30.0,
                  top: 10.0,
                  bottom: 20 + fontWeight * 2,
                ),
                child: Text(
                  widget.message.message,
                  style: TextStyle(
                    fontSize: 16 + fontWeight * 2,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 5.0,
                right: 5.0,
                child: Text(
                  _getTime(widget.message.time),
                  style: TextStyle(
                    fontSize: 12 + fontWeight,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _getTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, "0")}"
        ":${dateTime.minute.toString().padLeft(2, "0")}";
  }
}
