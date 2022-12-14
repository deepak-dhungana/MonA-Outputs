// Copyright 2013 The Flutter Authors. All rights reserved.

import 'dart:html' as html;

// Fake interface for the logic that this package needs from (web-only) dart:ui.
// This is conditionally exported so the analyzer sees these methods as available.
class platformViewRegistry {
  /// Shim for registerViewFactory
  /// https://github.com/flutter/engine/blob/master/lib/web_ui/lib/ui.dart#L72
  static registerViewFactory(
      String viewTypeId, html.Element Function(int viewId) viewFactory) {}
}

class webOnlyAssetManager {
  /// Shim for getAssetUrl.
  /// https://github.com/flutter/engine/blob/master/lib/web_ui/lib/src/engine/assets.dart#L45
  static getAssetUrl(String asset) {}
}

/// Signature of callbacks that have no arguments and return no data.
typedef VoidCallback = void Function();
