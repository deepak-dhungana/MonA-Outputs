import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart' show HtmlElementView;

import '../../dartui_shims/dart_ui.dart' as ui;

// camera tasks required by IO3 Krems game
enum CameraTasks { captureImage, recordVideo }

class MonAWebCameraService {
  final CameraTasks task;

  MonAWebCameraService({required this.task});

  // supported MIME types for video recording
  static const Map<String, String> _supportedMimeType = {
    'video/mp4': '.mp4',
    'video/webm': '.webm',
  };

  // camera stream
  html.MediaStream? _stream;

  // video element for the camera preview
  html.VideoElement? _cameraPreviewElement;

  // media recorder for recording video
  html.MediaRecorder? _videoRecorder;

  // container for recorded video data
  final List<html.Blob> _videoData = [];

  // Completes when the video recording is stopped/finished.
  Completer<MonAVideoFile>? _videoAvailableCompleter;

  /// Initializes the camera
  Future<void> initializeCamera() async {
    final mediaDevices = html.window.navigator.mediaDevices;

    if (mediaDevices == null) {
      throw MonAWebCameraException(
          message: "Camera is not supported on this device.");
    }

    /*
    IO3 Krems game:
        image capturing tasks: back camera ('facingMode': 'environment')
        video recording tasks: front camera ('facingMode': 'user')
     */

    try {
      if (task == CameraTasks.captureImage) {
        // try/catch if the device has to camera facing to the environment
        try {
          _stream = await mediaDevices.getUserMedia({
            'video': {
              'facingMode': {'exact': 'environment'},
              'width': {'ideal': 1280},
              'height': {'ideal': 720}
            }
          });
        } catch (e) {
          _stream = await mediaDevices.getUserMedia({
            'video': {'facingMode': 'user'},
            'width': {'ideal': 1280},
            'height': {'ideal': 720}
          });
        }
      } else {
        _stream = await mediaDevices.getUserMedia({
          'audio': true,
          'video': {'facingMode': 'user'},
          'width': {'ideal': 1280},
          'height': {'ideal': 720}
        });
      }
    } on html.DomException catch (e) {
      final String message = e.message ?? "";

      if (message == "NotAllowedError" || message == "PermissionDeniedError") {
        throw MonAWebCameraException(
            message: "Permission to access the camera is not granted.");
      } else {
        throw MonAWebCameraException(
            message:
                "An unknown error occurred when fetching the camera stream.");
      }
    } catch (_) {
      throw MonAWebCameraException(
          message:
              "An unknown error occurred when fetching the camera stream.");
    }
  }


  /// Creates camera preview
  Future<void> createCameraPreview() async {
    if (_stream == null) {
      throw MonAWebCameraException(
          message: "Came preview is longer accessible");
    }


    const String viewTypeID = 'mona_cam_web_preview';

    _cameraPreviewElement = html.VideoElement();

    html.DivElement divElement = html.DivElement()
      ..style.setProperty('object-fit', 'cover')
      ..append(_cameraPreviewElement!);


    _cameraPreviewElement!
      ..autoplay = false
      ..muted = true
      ..srcObject = _stream
      ..setAttribute('playsinline', '');

    _cameraPreviewElement!.style
      ..transformOrigin = 'center'
      ..pointerEvents = 'none'
      ..width = '100%'
      ..height = '100%'
      ..objectFit = 'cover';

    // flipping video horizontally for front camera
    if (task == CameraTasks.recordVideo) {
      _cameraPreviewElement!.style.transform = 'scaleX(-1)';
    }

    ui.platformViewRegistry.registerViewFactory(
      viewTypeID,
      (_) => divElement,
    );

    await _cameraPreviewElement!.play();
  }

  /// Takes picture
  Future<MonAImageFile> takePicture() async {

    if (_cameraPreviewElement == null) {
      throw MonAWebCameraException(message: "Error while taking picture!!!");
    }

    final int imgWidth = _cameraPreviewElement!.videoWidth;
    final int imgHeight = _cameraPreviewElement!.videoHeight;

    final html.CanvasElement canvas =
        html.CanvasElement(width: imgWidth, height: imgHeight);

    /*IMPORTANT
     *
     * Since the images will be taking always with back-camera,
     * hence the images are not handled for front-camera images.
     *
     * For front-camera picture the images need to flipped
     * horizontally.
     */

    canvas.context2D
        .drawImageScaled(_cameraPreviewElement!, 0, 0, imgWidth, imgHeight);

    final imageBlob = await canvas.toBlob('image/png');

    return MonAImageFile(
      imageBlobURL: html.Url.createObjectUrl(imageBlob),
      fileExtension: '.png',
    );
  }

  // #########################################################################

  /// returns supported video MIME types
  String _getVideoMimeType() {
    for (String mimeType in _supportedMimeType.keys) {
      if (html.MediaRecorder.isTypeSupported(mimeType)) {
        return mimeType;
      }
    }

    throw MonAWebCameraException(message: "MIME Types unsupported.");
  }

  Future<void> startVideoRecording() async {
    final String vidMimeType = _getVideoMimeType();

    _videoRecorder ??= html.MediaRecorder(_cameraPreviewElement!.srcObject!, {
      'mimeType': vidMimeType,
    });

    _videoAvailableCompleter = Completer<MonAVideoFile>();

    _videoRecorder!.addEventListener('dataavailable', (event) async {
      final vidBlob = (event as html.BlobEvent).data;

      if (vidBlob != null) {
        _videoData.add(vidBlob);
      }
    });

    _videoRecorder!.addEventListener('stop', (event) async {
      final videoType = _videoData.first.type;

      // merges a list of blobs into one
      final videoBlob = html.Blob(_videoData, videoType);

      // Create a video file containing the video blob.
      final MonAVideoFile monaVideoFile = MonAVideoFile(
        videoBlobURL: html.Url.createObjectUrl(videoBlob),
        fileExtension: _supportedMimeType[vidMimeType]!,
      );

      _videoAvailableCompleter?.complete(monaVideoFile);

      _videoRecorder!.removeEventListener('dataavailable', (_) {});

      _videoRecorder!.removeEventListener('stop', (_) {});

      _videoRecorder = null;
      _videoData.clear();
    });

    _videoRecorder!.start();
  }

  Future<MonAVideoFile> stopVideoRecording() async {
    if (_videoRecorder == null || _videoAvailableCompleter == null) {
      throw MonAWebCameraException(message: "Video recording never started!!!");
    }

    _videoRecorder!.stop();

    return _videoAvailableCompleter!.future;
  }

  /// Download the image/ video
  Future<void> downloadFile(
      {required String blobURL, required String fileName}) async {
    final anchorElement = html.document.createElement('a') as html.AnchorElement
      ..href = blobURL
      ..style.display = 'none'
      ..download = fileName;

    html.document.body!.children.add(anchorElement);

    anchorElement.click();

    html.document.body!.children.remove(anchorElement);
  }

  /// Closes the camera
  Future<void> closeCamera() async {
    _stream = null;
    _cameraPreviewElement = null;

    _videoRecorder = null;
    _videoData.clear();
    _videoAvailableCompleter = null;
  }
}

class MonAWebCameraException implements Exception {
  final String message;

  MonAWebCameraException({required this.message});

  @override
  String toString() {
    return 'MonAWebCameraException: $message';
  }
}

class MonAImageFile {
  final String imageBlobURL;

  final String fileExtension;

  final String fileName;

  MonAImageFile({required this.imageBlobURL, required this.fileExtension})
      : fileName = "karikatur_image_${DateTime.now().millisecondsSinceEpoch}" +
            fileExtension;

  @override
  String toString() {
    return "Blob URL: $imageBlobURL,\nFile Name: $fileName";
  }
}

class MonAVideoFile {
  final String videoBlobURL;

  final String fileExtension;

  final String fileName;

  MonAVideoFile({required this.videoBlobURL, required this.fileExtension})
      : fileName = "karikatur_video_${DateTime.now().millisecondsSinceEpoch}" +
            fileExtension;

  @override
  String toString() {
    return "Blob URL: $videoBlobURL,\nFile Name: $fileName";
  }
}
