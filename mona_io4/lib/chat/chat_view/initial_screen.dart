part of 'view.dart';

class ChatInitialBody extends StatelessWidget {
  const ChatInitialBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
      mediaQueryData: MediaQuery.of(context),
    );

    return _buildBodyByScreenType(context, screenInfo);
  }

  Widget _buildBodyByScreenType(
      BuildContext context, ScreenInformation screenInfo) {
    switch (screenInfo.screenType) {
      case ScreenType.mobilePortrait:
        return _buildMobilePortraitBody(context, screenInfo);

      case ScreenType.mobileLandscape:
        return _buildMobileLandscapeBody(context, screenInfo);

      case ScreenType.tabletPortrait:
        return _buildTabletBody(context, screenInfo);

      case ScreenType.tabletLandscape:
        return _buildTabletBody(context, screenInfo);
    }
  }

  Widget _buildMobilePortraitBody(
      BuildContext context, ScreenInformation screenInfo) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final Size screenSize = screenInfo.entireScreenSize;

    final double availableHeight = screenSize.height - screenInfo.topPadding;

    final double horizontalPadding = screenSize.width * 0.05;
    final double verticalPadding = availableHeight * 0.025;

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "assets/screen_background/chat_mobile_portrait.png"),
              fit: BoxFit.cover)),
      child: Padding(
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          top: screenInfo.topPadding + verticalPadding,
        ),
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/images/chat_init_hero.png",
              height: availableHeight * 0.40,
              width: screenSize.width * 0.80,
            ),
            SizedBox(
              height: availableHeight * 0.07,
            ),
            Text(
              appLocalizations.chat_init_txt_1,
              style: TextStyle(
                fontSize: screenSize.height * 0.026,
                fontFamily: "cera-gr-bold",
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: availableHeight * 0.01,
            ),
            Text(
              appLocalizations.chat_init_txt_2,
              style: const TextStyle(
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: screenSize.height * 0.08,
            ),
            ElevatedButton(
              onPressed: () {
                _onJoinChatRoom(context);
              },
              child: Text(
                appLocalizations.chat_init_join_btn,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "cera-gr-bold",
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(const Size(250.0, 50)),
                backgroundColor:
                    MaterialStateProperty.all(MonAColors.darkMagenta),
              ),
            ),
            // SizedBox(
            //   height: screenSize.height * 0.02,
            // ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                _onCreateChatRoom(context);
              },
              child: Text(
                appLocalizations.chat_init_create_btn,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "cera-gr-bold",
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                ),
                foregroundColor:
                    MaterialStateProperty.all(MonAColors.darkMagenta),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLandscapeBody(
      BuildContext context, ScreenInformation screenInfo) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final Size screenSize = screenInfo.entireScreenSize;

    final double availableHeight = screenInfo.safeHeight;
    final double availableWidth = screenSize.width - screenInfo.rightPadding;

    final double horizontalPadding = availableWidth * 0.01;

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "assets/screen_background/chat_mobile_landscape.png"),
              fit: BoxFit.cover)),
      child: Padding(
        padding: EdgeInsets.only(
            left: horizontalPadding,
            right: screenInfo.rightPadding + horizontalPadding,
            bottom: screenInfo.bottomPadding),
        child: Row(
          children: <Widget>[
            Image.asset(
              "assets/images/chat_init_hero.png",
              height: availableHeight * 0.80,
              width: availableWidth * 0.40,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appLocalizations.chat_init_txt_1,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontFamily: "cera-gr-bold",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: availableHeight * 0.01,
                  ),
                  Text(
                    appLocalizations.chat_init_txt_2,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: screenSize.height * 0.08,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _onJoinChatRoom(context);
                    },
                    child: Text(
                      appLocalizations.chat_init_join_btn,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "cera-gr-bold",
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(const Size(250.0, 50.0)),
                      backgroundColor:
                          MaterialStateProperty.all(MonAColors.darkMagenta),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  TextButton(
                    onPressed: () {
                      _onCreateChatRoom(context);
                    },
                    child: Text(
                      appLocalizations.chat_init_create_btn,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "cera-gr-bold",
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                      ),
                      foregroundColor:
                          MaterialStateProperty.all(MonAColors.darkMagenta),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletBody(BuildContext context, ScreenInformation screenInfo) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final Size screenSize = screenInfo.entireScreenSize;

    final double availableHeight = screenSize.height - screenInfo.topPadding;

    final double horizontalPadding = screenSize.width * 0.05;
    final double verticalPadding = availableHeight * 0.025;

    return Container(
      decoration: BoxDecoration(
          color: MonAColors.screenBackgroundColor,
          image: DecorationImage(
              image: AssetImage(
                  screenInfo.screenOrientation == Orientation.portrait
                      ? "assets/screen_background/chat_tablet_portrait.png"
                      : "assets/screen_background/chat_tablet_landscape.png"),
              fit: BoxFit.fitWidth)),
      // color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          top: screenInfo.topPadding + verticalPadding,
        ),
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/images/chat_init_hero.png",
              height: availableHeight * 0.40,
              width: screenSize.width * 0.80,
            ),
            SizedBox(
              height: availableHeight * 0.10,
            ),
            Text(
              appLocalizations.chat_init_txt_1,
              style: const TextStyle(
                fontSize: 30.0,
                fontFamily: "cera-gr-bold",
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: availableHeight * 0.01,
            ),
            Text(
              appLocalizations.chat_init_txt_2,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: screenSize.height * 0.08,
            ),
            ElevatedButton(
              onPressed: () {
                _onJoinChatRoom(context);
              },
              child: Text(
                appLocalizations.chat_init_join_btn,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontFamily: "cera-gr-bold",
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(const Size(350.0, 50.0)),
                backgroundColor:
                    MaterialStateProperty.all(MonAColors.darkMagenta),
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            TextButton(
              onPressed: () {
                _onCreateChatRoom(context);
              },
              child: Text(
                appLocalizations.chat_init_create_btn,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontFamily: "cera-gr-bold",
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                ),
                foregroundColor:
                    MaterialStateProperty.all(MonAColors.darkMagenta),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Called when the user presses "Create Room" button
  void _onCreateChatRoom(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Create Room Dialog",
      pageBuilder: (_, __, ___) {
        return ChatCreateScreen(
          parentContext: context,
        );
      },
    );
  }

  /// Called when the user presses "Join Room" button
  void _onJoinChatRoom(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Join Room Dialog",
      pageBuilder: (_, __, ___) {
        return ChatJoinScreen(
          parentContext: context,
        );
      },
    );
  }
}
