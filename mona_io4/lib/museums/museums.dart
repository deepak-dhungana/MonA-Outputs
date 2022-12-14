import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../colors.dart';
import 'museum_card/museum_card.dart';
import 'museum_logic/museum_logic.dart';
import '../../responsive_and_adaptive/screen_info.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'museums_mobile_portrait.dart';

part 'museums_mobile_landscape.dart';

part 'museums_tablet_portrait.dart';

part 'museums_tablet_landscape.dart';

class Museums extends StatefulWidget {
  const Museums({Key? key}) : super(key: key);

  @override
  _MuseumsState createState() => _MuseumsState();
}

class _MuseumsState extends State<Museums> with AutomaticKeepAliveClientMixin {
  // PageController for MuseumPage [used for mobile portrait and landscape]
  final PageController _pageController = PageController();

  // Page key
  final GlobalKey<_MuseumsState> _pageKey = GlobalKey<_MuseumsState>();

  // Scroll controller for ListView (Tablet portrait and landscape)
  final ScrollController _listViewController = ScrollController();

  // State Management
  bool _errorFetchingMuseumsCount = false;
  bool _museumsCountFetched = false;

  // Fetched Folder Names
  List<String>? _folderNames;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // fetch museum folders [number of museums]
    _fetchMuseumFolders();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
      mediaQueryData: MediaQuery.of(context),
    );

    return _buildBodyByScreenType(screenInfo);
  }

  Widget _buildBodyByScreenType(ScreenInformation screenInfo) {
    switch (screenInfo.screenType) {
      case ScreenType.mobilePortrait:
        return _buildMobilePortraitBody(screenInfo);

      case ScreenType.mobileLandscape:
        return _buildMobileLandscapeBody(screenInfo);

      case ScreenType.tabletPortrait:
        return _buildTabletPortraitBody(screenInfo);

      case ScreenType.tabletLandscape:
        return _buildTabletLandscapeBody(screenInfo);
    }
  }

  Widget _buildMobilePortraitBody(ScreenInformation screenInfo) {
    if (_errorFetchingMuseumsCount) {
      return _buildMobilePortraitErrorBody(screenInfo);
    }

    if (!_museumsCountFetched) {
      return _buildFetchingInProgressBody();
    }

    // else return the view with museum cards
    return _museumMobilePortrait(
      context: context,
      pageKey: _pageKey,
      screenInfo: screenInfo,
      pageController: _pageController,
      folderNames: _folderNames!,
    );
  }

  Widget _buildMobileLandscapeBody(ScreenInformation screenInfo) {
    if (_errorFetchingMuseumsCount) {
      return _buildMobileLandscapeErrorBody(screenInfo);
    }

    if (!_museumsCountFetched) {
      return _buildFetchingInProgressBody();
    }
    // else return the view with museum cards
    return _museumMobileLandscape(
      context: context,
      pageKey: _pageKey,
      screenInfo: screenInfo,
      pageController: _pageController,
      folderNames: _folderNames!,
    );
  }

  Widget _buildTabletPortraitBody(ScreenInformation screenInfo) {
    if (_errorFetchingMuseumsCount) {
      return _buildTabletErrorBody(screenInfo.entireScreenSize.width);
    }

    if (!_museumsCountFetched) {
      return _buildFetchingInProgressBody();
    }
    // else return the view with museum cards
    return _museumTabletPortrait(
      listViewController: _listViewController,
      context: context,
      screenInfo: screenInfo,
      folderNames: _folderNames!,
    );
  }

  Widget _buildTabletLandscapeBody(ScreenInformation screenInfo) {
    if (_errorFetchingMuseumsCount) {
      return _buildTabletErrorBody(screenInfo.entireScreenSize.width);
    }

    if (!_museumsCountFetched) {
      return _buildFetchingInProgressBody();
    }
    // else return the view with museum cards
    return _museumTabletLandscape(
      context: context,
      listViewController: _listViewController,
      screenInfo: screenInfo,
      folderNames: _folderNames!,
    );
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
              AppLocalizations.of(context)!.museums_error,
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
                    AppLocalizations.of(context)!.museums_error,
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
                        AppLocalizations.of(context)!.museums_error,
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

  void _fetchMuseumFolders() async {
    try {
      _folderNames = await MuseumUtil.getMuseumFoldersName();

      if (mounted) {
        setState(() {
          _museumsCountFetched = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorFetchingMuseumsCount = true;
        });
      }
    }
  }

  void _reset() async {
    if (mounted) {
      setState(() {
        _errorFetchingMuseumsCount = false;
        _museumsCountFetched = false;

        // Fetched Folder Names
        _folderNames = null;
      });
    }
    Future.delayed(const Duration(milliseconds: 800),(){
      _fetchMuseumFolders();
    });
  }
}
