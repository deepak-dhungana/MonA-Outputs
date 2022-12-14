import 'package:flutter/material.dart';

import '../colors.dart';
import 'downloads_card/card_page.dart';
import 'downloads_logic/downloads_logic.dart';
import '../../responsive_and_adaptive/screen_info.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'downloads_mobile_portrait.dart';

part 'downloads_mobile_landscape.dart';

part 'downloads_tablet_portrait.dart';

part 'downloads_tablet_landscape.dart';

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // code language mapping
  static const Map<String, String> _codeLangMapping = {
    "en": "English",
    "de": "Deutsch",
    "el": "Ελληνικά",
    "it": "Italiano",
    "nl": "Nederlands",
  };

  // code language mapping
  static const Map<String, String> _codeCountryMapping = {
    "en": "us",
    "de": "at",
    "el": "gr",
    "it": "it",
    "nl": "nl",
  };

  // for state management
  bool _errorFetchingFileNames = false;
  bool _fileNamesFetched = false;

  // list of fetched file names
  final List _fetchedFileNames = [];

  // Tab Controller for Mobile Portrait and Landscape View
  late final TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _fetchFileNames();

    super.initState();

    // for 5 supported languages
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
      mediaQueryData: MediaQuery.of(context),
    );

    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return _buildBodyByScreenType(screenInfo, appLocalizations);
  }

  Widget _buildBodyByScreenType(
      ScreenInformation screenInfo, AppLocalizations appLocalizations) {
    switch (screenInfo.screenType) {
      case ScreenType.mobilePortrait:
        return _buildMobilePortraitBody(screenInfo, appLocalizations);

      case ScreenType.mobileLandscape:
        return _buildMobileLandscapeBody(screenInfo, appLocalizations);

      case ScreenType.tabletPortrait:
        return _buildTabletPortraitBody(screenInfo, appLocalizations);

      case ScreenType.tabletLandscape:
        return _buildTabletLandscapeBody(screenInfo, appLocalizations);
    }
  }

  Widget _buildMobilePortraitBody(
      ScreenInformation screenInfo, AppLocalizations appLocalizations) {
    if (_errorFetchingFileNames) {
      return _buildMobilePortraitErrorBody(screenInfo);
    }

    if (!_fileNamesFetched) {
      return _buildFetchingInProgressBody();
    }

    // else return the view with museum cards
    return _downloadsMobilePortrait(
        screenInfo: screenInfo,
        appLocalizations: appLocalizations,
        fileNames: _fetchedFileNames,
        tabController: _tabController);
  }

  Widget _buildMobileLandscapeBody(
      ScreenInformation screenInfo, AppLocalizations appLocalizations) {
    if (_errorFetchingFileNames) {
      return _buildMobileLandscapeErrorBody(screenInfo);
    }

    if (!_fileNamesFetched) {
      return _buildFetchingInProgressBody();
    }

    // else return the view with museum cards
    return _downloadsMobileLandscape(
        screenInfo: screenInfo,
        appLocalizations: appLocalizations,
        fileNames: _fetchedFileNames,
        tabController: _tabController);
  }

  Widget _buildTabletPortraitBody(
      ScreenInformation screenInfo, AppLocalizations appLocalizations) {
    if (_errorFetchingFileNames) {
      return _buildTabletErrorBody(screenInfo.entireScreenSize.width);
    }

    if (!_fileNamesFetched) {
      return _buildFetchingInProgressBody();
    }

    // else return the view with museum cards
    return _downloadsTabletPortrait(
        screenInfo: screenInfo,
        appLocalizations: appLocalizations,
        fileNames: _fetchedFileNames);
  }

  Widget _buildTabletLandscapeBody(
      ScreenInformation screenInfo, AppLocalizations appLocalizations) {
    if (_errorFetchingFileNames) {
      return _buildTabletErrorBody(screenInfo.entireScreenSize.width);
    }

    if (!_fileNamesFetched) {
      return _buildFetchingInProgressBody();
    }

    // else return the view with museum cards
    return _downloadsTabletLandscape(
        screenInfo: screenInfo,
        appLocalizations: appLocalizations,
        fileNames: _fetchedFileNames,
        tabController: _tabController);
  }

  // ###########################################################################

  Widget _buildFetchingInProgressBody() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildMobilePortraitErrorBody(ScreenInformation screenInfo) {
    final Size screenSize = screenInfo.entireScreenSize;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: const BoxDecoration(
        color: MonAColors.errorColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/sad_face.png",
            height: screenSize.height * 0.30,
            width: screenSize.width * 0.60,
          ),
          const SizedBox(
            height: 35.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              AppLocalizations.of(context)!.downloads_error,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "cera-gr-medium",
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () {
              _reset();
            },
            child: Text(
              AppLocalizations.of(context)!.try_again,
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "cera-gr-bold",
                  fontSize: 18.0),
            ),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(const Size(200.0, 45.0)),
                backgroundColor: MaterialStateProperty.all(Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLandscapeErrorBody(ScreenInformation screenInfo) {
    final Size screenSize = screenInfo.entireScreenSize;

    return Container(
      padding:
          EdgeInsets.only(left: 15.0, right: screenInfo.rightPadding + 15.0),
      decoration: const BoxDecoration(
        color: MonAColors.errorColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/sad_face.png",
            height: screenSize.height * 0.50,
            width: screenSize.width * 0.25,
          ),
          const SizedBox(
            width: 15.0,
          ),
          Flexible(
            child: SizedBox(
              width: screenSize.width * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.downloads_error,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "cera-gr-medium",
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _reset();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.try_again,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "cera-gr-bold",
                          fontSize: 18.0),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                        ),
                        minimumSize:
                            MaterialStateProperty.all(const Size(200.0, 45.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabletErrorBody(double availableWidth) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: availableWidth * 0.05),
        child: SizedBox(
          height: 300,
          child: Card(
            color: MonAColors.errorColor,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/sad_face.png",
                  height: 200.0,
                ),
                SizedBox(
                  width: availableWidth * 0.03,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.downloads_error,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "cera-gr-medium",
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _reset();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.try_again,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "cera-gr-bold",
                              fontSize: 18.0),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all(
                                const Size(200.0, 45.0)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ###########################################################################
  void _fetchFileNames() async {
    try {
      final _fileNames = await DownloadsUtil.getDownloadsFileNames();

      _codeLangMapping.forEach((key, value) {
        _fetchedFileNames
            .add([value, _fileNames[key], _codeCountryMapping[key]]);
      });

      setState(() {
        _fileNamesFetched = true;
      });
    } catch (e) {
      setState(() {
        _errorFetchingFileNames = true;
      });
    }
  }

  void _reset() async {
    if (mounted) {
      setState(() {
        _errorFetchingFileNames = false;
        _fileNamesFetched = false;

        // Fetched Folder Names
        _fetchedFileNames.clear();
      });
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      _fetchFileNames();
    });
  }
}
