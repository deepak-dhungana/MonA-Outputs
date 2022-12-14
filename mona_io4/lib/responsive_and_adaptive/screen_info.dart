import 'package:flutter/widgets.dart';

enum ScreenType {
  mobilePortrait,
  mobileLandscape,
  tabletPortrait,
  tabletLandscape
}

class ScreenInformation {
  final MediaQueryData mediaQueryData;

  ScreenInformation.fromMediaQueryData({required this.mediaQueryData});

  Size get entireScreenSize => mediaQueryData.size;

  Orientation get screenOrientation => mediaQueryData.orientation;

  double get topPadding => mediaQueryData.padding.top;

  double get bottomPadding => mediaQueryData.padding.bottom;

  double get bottomViewInsets => mediaQueryData.viewInsets.bottom;

  double get leftPadding => mediaQueryData.padding.left;

  double get rightPadding => mediaQueryData.padding.right;

  double get safeHeight =>
      entireScreenSize.height - (topPadding + bottomPadding);

  double get safeWidth => entireScreenSize.width - (leftPadding + rightPadding);

  ScreenType get screenType {
    // screen orientation is PORTRAIT
    if (screenOrientation == Orientation.portrait) {
      // comparing the width [since device is in portrait orientation]
      if (entireScreenSize.width < 600) {
        return ScreenType.mobilePortrait;
      }

      return ScreenType.tabletPortrait;
    }
    // screen orientation is LANDSCAPE
    else {
      // comparing the height [since device is in landscape orientation]
      if (entireScreenSize.height < 600) {
        return ScreenType.mobileLandscape;
      }

      return ScreenType.tabletLandscape;
    }
  }
}
