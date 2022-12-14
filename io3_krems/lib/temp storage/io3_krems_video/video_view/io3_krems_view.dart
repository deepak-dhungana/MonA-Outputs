import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io3_krems/colors.dart';
import 'package:io3_krems/io3_krems_video/video_bloc/video_bloc.dart';
import '../../io3_krems_config.dart';
import '../../screen_info.dart';

import 'dart:html' as html;
import '../../dartui_shims/dart_ui.dart' as ui;

class IO3KremsView extends StatelessWidget {
  const IO3KremsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenInfo = ScreenInformation.fromMediaQueryData(
        mediaQueryData: MediaQuery.of(context));

    final screenSize = screenInfo.entireScreenSize;

    return BlocBuilder<IO3KremsVideoBloc, IO3KremsVideoState>(
        builder: (blocContext, state) {
      if (state is PermissionReqInProgress) {
        return Center(
          child: Transform.scale(
              scale: 2, child: const CircularProgressIndicator()),
        );
      }

      if (state is ErrorState) {
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
                      blocContext.read<IO3KremsVideoBloc>().add(ResetState());
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

      if (state is IO3KremsVideoRecordingInit) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const HtmlElementView(viewType: 'mona_cam_web_preview'),
            Column(
              children: [
                Container(
                  height: screenSize.height * 0.05,
                  color: Colors.black.withOpacity(0.70),
                  child: Center(
                    child: Text(
                      "00 : 00",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.height * 0.02,
                        fontFamily: "cera-gr-regular",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.85,
                ),
                Container(
                  height: screenSize.height * 0.10,
                  color: Colors.black.withOpacity(0.70),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        blocContext
                            .read<IO3KremsVideoBloc>()
                            .add(StartVideoRecording());
                      },
                      // subtracting the 8.0 padding on all side
                      iconSize: (screenSize.height * 0.07) - 8.0,
                      icon: const Icon(
                        Icons.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }

      if (state is IO3KremsVideoRecordingInProgress) {
        final int timeElapsed = state.elapsedTime;

        final minutesStr =
            ((timeElapsed / 60) % 60).floor().toString().padLeft(2, '0');
        final secondsStr =
            (timeElapsed % 60).floor().toString().padLeft(2, '0');

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const HtmlElementView(viewType: 'mona_cam_web_preview'),
            Column(
              children: [
                Container(
                  height: screenSize.height * 0.05,
                  color: Colors.black.withOpacity(0.70),
                  child: Center(
                    child: Text(
                      '$minutesStr : $secondsStr',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.height * 0.02,
                        fontFamily: "cera-gr-regular",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.85,
                ),
                Container(
                  height: screenSize.height * 0.10,
                  color: Colors.black.withOpacity(0.70),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        blocContext
                            .read<IO3KremsVideoBloc>()
                            .add(StopVideoRecording());
                      },
                      // subtracting the 8.0 padding on all side
                      iconSize: (screenSize.height * 0.07) - 8.0,
                      icon: const Icon(
                        Icons.stop_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }

      if (state is IO3KremsVideoRecordingComplete) {
        html.VideoElement vidElement = html.VideoElement();

        html.DivElement divElement = html.DivElement()
          ..style.setProperty('object-fit', 'cover')
          ..append(vidElement);

        vidElement
          ..autoplay = true
          ..controls = true
          ..muted = true
          ..src = state.videoFile.videoBlobURL
          ..setAttribute('playsinline', 'true');

        vidElement.style
          ..transformOrigin = 'center'
          ..width = '100%'
          ..height = '100%'
          ..objectFit = 'cover';

        ui.platformViewRegistry.registerViewFactory(
          'video_view',
          (_) => divElement,
        );

        return Stack(
          children: [
            const HtmlElementView(viewType: 'video_view'),
            Positioned(
                bottom: screenInfo.bottomPadding + 70,
                right: screenInfo.rightPadding + 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        blocContext
                            .read<IO3KremsVideoBloc>()
                            .add(DownloadVideo(state.videoFile));
                      },
                      icon: const Icon(
                        Icons.file_download,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Video herunterladen",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: MonAColors.darkMagenta,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        html.window.location.replace(IO3KremsConfig.afterVideoURL);
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
                ))
          ],
        );
      }

      return Container();
    });
  }
}
