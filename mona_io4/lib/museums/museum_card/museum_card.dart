import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mona/mona_locale.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors.dart';
import '../../app_config/app_config.dart';
import '../museum_logic/museum_logic.dart';
import '../museum_logic/museum_model.dart';
import '../../responsive_and_adaptive/screen_info.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MuseumCard extends StatefulWidget {
  final String museumFolderName;

  const MuseumCard({Key? key, required this.museumFolderName})
      : super(key: key);

  @override
  _MuseumCardState createState() => _MuseumCardState();
}

class _MuseumCardState extends State<MuseumCard>
    with AutomaticKeepAliveClientMixin {
  // For state management
  bool _errorFetchingInformation = false;
  bool _informationFetched = false;

  // Fetched museum and corresponding image
  Museum? museum;
  Image? museumImage;

  @override
  bool get wantKeepAlive => true;

  // MonA Locale provider
  late final MonALocaleProvider _monaLocaleProvide;

  @override
  void initState() {
    // fetches folder contents
    _fetchMuseumContents();

    super.initState();

    _monaLocaleProvide =
        Provider.of<MonALocaleProvider>(context, listen: false);
    _monaLocaleProvide.addListener(() {
      _fetchMuseumContents();
    });
  }

  @override
  void dispose() {
    _monaLocaleProvide.removeListener(() {});
    _monaLocaleProvide.dispose();
    super.dispose();
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
        return _buildMobilePortraitBody();

      case ScreenType.mobileLandscape:
        return _buildMobileLandscapeBody();

      case ScreenType.tabletPortrait:
        return _buildTabletPortraitBody(
          screenInfo.entireScreenSize.height,
        );

      case ScreenType.tabletLandscape:
        return _buildTabletLandscapeBody(
          screenInfo.entireScreenSize.height,
        );
    }
  }

  // ###########################################################################
  // MOBILE PORTRAIT

  Widget _buildMobilePortraitBody() {
    return LayoutBuilder(builder: (lbContext, lbConstraints) {
      final availableWidth = lbConstraints.maxWidth;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: availableWidth * 0.05),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: _getMobilePortraitBody(),
          elevation: 10.0,
          shadowColor: const Color(0x8035136D).withOpacity(0.50),
        ),
      );
    });
  }

  Widget _getMobilePortraitBody() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final bool isDE = Localizations.localeOf(context).languageCode == "de";

    if (_errorFetchingInformation) {
      return _buildPortraitErrorCardBody();
    }

    if (!_informationFetched) {
      return _buildLoadingCardBody();
    }

    return LayoutBuilder(builder: (lbContext, lbConstraints) {
      final double availableHeight = lbConstraints.maxHeight;
      final double availableWidth = lbConstraints.maxWidth;

      final double firstSectionHeight = availableHeight * 0.02;
      final double secondSectionHeight = availableHeight * 0.48;
      final double thirdSectionHeight = availableHeight * 0.50;

      return Column(
        children: [
          Container(
            height: firstSectionHeight,
            width: availableWidth,
            decoration: BoxDecoration(
              color: monaMaterialMagenta,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Image(
                image: museumImage!.image,
                fit: BoxFit.cover,
                height: secondSectionHeight,
                width: availableWidth,
              ),
              Container(
                height: secondSectionHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                    colors: [
                      const Color(0xFFEEEEEE).withOpacity(0.90),
                      const Color(0xFFCFCFCF).withOpacity(0.20),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            museum!.museumName.toUpperCase(),
                            style: TextStyle(
                              fontFamily: isDE ? "roboto" : "cera-gr-black",
                              fontWeight: FontWeight.w900,
                              fontSize: availableWidth * 0.08,
                              color: MonAColors.darkMagenta,
                              height: 1.1,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.black87,
                              size: 24.0,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              museum!.location,
                              style: TextStyle(
                                fontFamily: isDE ? "roboto" : "cera-gr-medium",
                                fontSize: availableWidth * 0.048,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: thirdSectionHeight,
            decoration: const BoxDecoration(
              color: Colors.white,
              // color: Color(0xFFF3F4Fd),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    museum!.description,
                    style: TextStyle(
                        fontSize: availableHeight * 0.0275,
                        fontFamily: isDE ? "roboto" : "cera-gr-bold",
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.grey,
                    height: 2,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchVirtualTour();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          appLocalizations.virtual_tour,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "cera-gr-bold",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(availableWidth - 15.0, 50.0),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(MonAColors.darkGreen),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchARGame();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          appLocalizations.ar_game,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "cera-gr-bold",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(availableWidth - 15.0, 50.0),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(MonAColors.darkYellow),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  // ###########################################################################
  // MOBILE LANDSCAPE

  Widget _buildMobileLandscapeBody() {
    return LayoutBuilder(builder: (lbContext, lbConstraints) {
      final availableHeight = lbConstraints.maxHeight;
      final availableWidth = lbConstraints.maxWidth;

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: availableWidth * 0.02,
          vertical: availableHeight * 0.05,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: _getMobileLandscapeBody(),
          elevation: 10.0,
          shadowColor: const Color(0x806400FF),
        ),
      );
    });
  }

  Widget _getMobileLandscapeBody() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final bool isDE = Localizations.localeOf(context).languageCode == "de";

    if (_errorFetchingInformation) {
      return _buildLandscapeErrorCardBody();
    }

    if (!_informationFetched) {
      return _buildLoadingCardBody();
    }

    return LayoutBuilder(builder: (lbContext, lbConstraints) {
      final double availableHeight = lbConstraints.maxHeight;
      final double availableWidth = lbConstraints.maxWidth;

      return Row(
        children: [
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
                child: Image(
                  image: museumImage!.image,
                  fit: BoxFit.cover,
                  height: availableHeight,
                  width: availableWidth * 0.55,
                ),
              ),
              Container(
                width: availableWidth * 0.55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                    colors: [
                      const Color(0xFFEEEEEE).withOpacity(0.90),
                      const Color(0xFFCFCFCF).withOpacity(0.20),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                          ),
                          child: Text(
                            museum!.museumName.toUpperCase(),
                            style: TextStyle(
                              fontFamily: isDE ? "roboto" : "cera-gr-black",
                              fontWeight: FontWeight.w900,
                              fontSize: availableHeight * 0.08,
                              color: MonAColors.darkMagenta,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.black87,
                              size: 24.0,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              museum!.location,
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: availableHeight * 0.048,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: availableWidth * 0.435,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    museum!.description,
                    style: TextStyle(
                      fontSize: availableWidth * 0.025,
                      fontFamily: "cera-gr-bold",
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.grey,
                    height: 2,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchVirtualTour();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          appLocalizations.virtual_tour,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "cera-gr-bold",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(availableWidth - 15.0, 50.0),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(MonAColors.darkGreen),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchARGame();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          appLocalizations.ar_game,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "cera-gr-bold",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(availableWidth - 15.0, 50.0),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(MonAColors.darkYellow),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: availableWidth * 0.015,
            decoration: BoxDecoration(
              color: monaMaterialMagenta,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(6.0),
                bottomRight: Radius.circular(6.0),
              ),
            ),
          ),
        ],
      );
    });
  }

  // ###########################################################################
  // TABLET PORTRAIT

  Widget _buildTabletPortraitBody(double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.225,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: _getTabletPortraitBody(),
        elevation: 10.0,
        shadowColor: const Color(0x806400FF),
      ),
    );
  }

  Widget _getTabletPortraitBody() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    if (_errorFetchingInformation) {
      return _buildLandscapeErrorCardBody();
    }

    if (!_informationFetched) {
      return _buildLoadingCardBody();
    }

    return LayoutBuilder(builder: (lbContext, lbConstraints) {
      final double availableHeight = lbConstraints.maxHeight;
      final double availableWidth = lbConstraints.maxWidth;

      return Row(
        children: [
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
                child: Image(
                  image: museumImage!.image,
                  fit: BoxFit.cover,
                  height: availableHeight,
                  width: availableWidth * 0.55,
                ),
              ),
              Container(
                width: availableWidth * 0.55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                    colors: [
                      const Color(0xFFEEEEEE).withOpacity(0.90),
                      const Color(0xFFCFCFCF).withOpacity(0.20),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                          ),
                          child: Text(
                            museum!.museumName.toUpperCase(),
                            style: TextStyle(
                              fontFamily: "cera-gr-black",
                              fontSize: availableHeight * 0.11,
                              color: MonAColors.darkMagenta,
                              height: 0.9,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.black87,
                              size: 22.0,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              museum!.location,
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: availableHeight * 0.06,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: availableWidth * 0.435,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    museum!.description,
                    style: TextStyle(
                      fontSize: availableHeight * 0.055,
                      fontFamily: "cera-gr-bold",
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.grey,
                    height: 2,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchVirtualTour();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          appLocalizations.virtual_tour,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "cera-gr-bold",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(availableWidth - 15.0, availableHeight * 0.18),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(MonAColors.darkGreen),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchARGame();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          appLocalizations.ar_game,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "cera-gr-bold",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(availableWidth - 15.0, availableHeight * 0.18),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(MonAColors.darkYellow),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: availableWidth * 0.015,
            decoration: BoxDecoration(
              color: monaMaterialMagenta,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(6.0),
                bottomRight: Radius.circular(6.0),
              ),
            ),
          ),
        ],
      );
    });
  }

  // ###########################################################################
  // TABLET LANDSCAPE

  Widget _buildTabletLandscapeBody(double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.29,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: _getTabletLandscapeBody(),
        elevation: 10.0,
        shadowColor: const Color(0x806400FF),
      ),
    );
  }

  Widget _getTabletLandscapeBody() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    if (_errorFetchingInformation) {
      return _buildLandscapeErrorCardBody();
    }

    if (!_informationFetched) {
      return _buildLoadingCardBody();
    }

    return LayoutBuilder(builder: (lbContext, lbConstraints) {
      final double availableHeight = lbConstraints.maxHeight;
      final double availableWidth = lbConstraints.maxWidth;

      return Row(
        children: [
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
                child: Image(
                  image: museumImage!.image,
                  fit: BoxFit.cover,
                  height: availableHeight,
                  width: availableWidth * 0.585,
                ),
              ),
              Container(
                width: availableWidth * 0.585,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                    colors: [
                      const Color(0xFFEEEEEE).withOpacity(0.90),
                      const Color(0xFFCFCFCF).withOpacity(0.20),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 5.0,
                            right: availableWidth * 0.10,
                          ),
                          child: Text(
                            museum!.museumName.toUpperCase(),
                            style: TextStyle(
                              fontFamily: "cera-gr-black",
                              fontSize: availableHeight * 0.12,
                              color: MonAColors.darkMagenta,
                              height: 0.9,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.black87,
                              size: 24.0,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              museum!.location,
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: availableHeight * 0.06,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: availableWidth * 0.40,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    museum!.description,
                    style: TextStyle(
                      fontSize: availableHeight * 0.068,
                      fontFamily: "cera-gr-bold",
                      height: 0.9,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.grey,
                    height: 2,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchVirtualTour();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          appLocalizations.virtual_tour,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "cera-gr-bold",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(availableWidth - 15.0, availableHeight * 0.18),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(MonAColors.darkGreen),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchARGame();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          appLocalizations.ar_game,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "cera-gr-bold",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(availableWidth - 15.0, availableHeight * 0.18),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(MonAColors.darkYellow),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: availableWidth * 0.015,
            decoration: BoxDecoration(
              color: monaMaterialMagenta,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(6.0),
                bottomRight: Radius.circular(6.0),
              ),
            ),
          ),
        ],
      );
    });
  }

  // ###########################################################################
  // ###########################################################################

  /// Fetches a museum content from a given folder
  void _fetchMuseumContents() async {
    try {
      List<String> _museumContentList =
          await MuseumUtil.getContentsFromMuseumFolder(
              folderName: widget.museumFolderName);

      // asset paths in a map
      // "info_url" for "information_(en|de|el|it|nl).txt"
      // "museum_image_url" for "museum_image.png|jpg|jpeg| or whatever"
      final Map<String, String> assetPaths = await _parseFilePaths(
          fileNames: _museumContentList, context: context);

      Uint8List _museumInformation =
          await MuseumUtil.downloadMuseumFile(url: assetPaths["info_url"]!);

      //decode the string
      Map<String, String> _museumInfoMap =
          await _parseStrToJson(responseBody: _museumInformation);

      // initialize the Museum
      museum = Museum.fromJson(_museumInfoMap);

      if (museumImage == null) {
        // initialize the museum image
        Uint8List _museumImageBytes = await MuseumUtil.downloadMuseumImage(
            imageURL: assetPaths["museum_image_url"]!);

        museumImage = Image.memory(_museumImageBytes);
      }

      if (mounted) {
        setState(() {
          _informationFetched = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorFetchingInformation = true;
        });
      }
    }
  }

  /// Parses a given file path
  static Future<Map<String, String>> _parseFilePaths(
      {required List<String> fileNames, required BuildContext context}) async {
    assert(
        fileNames.length == 6, "There must be exactly 6 elements in the list");

    Map<String, String> assetPaths = {};

    final String localizedFileName =
        "information_${Localizations.localeOf(context).languageCode}.txt";

    for (String element in fileNames) {
      if (RegExp(localizedFileName).hasMatch(element)) {
        // information URL
        assetPaths["info_url"] =
            MonAConfiguration.monaBaseURL + element.substring(1);
      } else if (RegExp(r"museum_image.[a-z]+").hasMatch(element)) {
        // museum image URL
        assetPaths["museum_image_url"] =
            MonAConfiguration.monaBaseURL + element.substring(1);
      }
    }

    return assetPaths;
  }

  /// Parses a map of <String, String> to json
  static Future<Map<String, String>> _parseStrToJson(
      {required Uint8List responseBody}) async {
    return jsonDecode(utf8.decode(responseBody)).cast<String, String>();
  }

  // ###########################################################################

  void _launchARGame() async {
    // show the user a warning dialog before going to the AR game
    // Required by Google Play policy

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "AR Alert Dialog",
      pageBuilder: (_, __, ___) {
        return ARAlertDialog(
          arGameUrl: museum!.gameURL,
        );
      },
    );

    // await launch(
    //   museum!.gameURL,
    //   enableJavaScript: true,
    // );
  }

  /// Launches the
  void _launchVirtualTour() async {
    await launch(
      museum!.vrTourURL,
      enableJavaScript: true,
    );
  }

  // ###########################################################################

  Widget _buildPortraitErrorCardBody() {
    return LayoutBuilder(builder: (lbContext, lbConstraints) {
      final double availableHeight = lbConstraints.maxHeight;
      final double availableWidth = lbConstraints.maxWidth;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: const BoxDecoration(
          color: MonAColors.errorColor,
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/sad_face.png",
              height: availableHeight * 0.35,
              width: availableWidth * 0.70,
            ),
            const SizedBox(
              height: 35.0,
            ),
            Text(
              AppLocalizations.of(context)!.museums_error,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "cera-gr-medium",
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLandscapeErrorCardBody() {
    return LayoutBuilder(builder: (lbContext, lbConstraints) {
      final double availableHeight = lbConstraints.maxHeight;
      final double availableWidth = lbConstraints.maxWidth;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: const BoxDecoration(
          color: MonAColors.errorColor,
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/sad_face.png",
              height: availableHeight * 0.70,
              width: availableWidth * 0.35,
            ),
            const SizedBox(
              width: 15.0,
            ),
            Flexible(
              child: SizedBox(
                width: availableWidth * 0.45,
                child: Text(
                  AppLocalizations.of(context)!.museums_error,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "cera-gr-medium",
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLoadingCardBody() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

// ############################################################################

class ARAlertDialog extends StatefulWidget {
  final String arGameUrl;

  const ARAlertDialog({Key? key, required this.arGameUrl}) : super(key: key);

  @override
  _ARAlertDialogState createState() => _ARAlertDialogState();
}

class _ARAlertDialogState extends State<ARAlertDialog> {
  // Scroll controller for ListView
  final ScrollController _scrollController = ScrollController();

  // Controls the visibility of scroll indicator
  bool _indicatorVisibility = false;

  late double _maxScrollExtent;
  late double _maxScrollExtentPadded;

  double _fontSize = 16;
  double _buttonTextSize = 18;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _maxScrollExtent = _scrollController.position.maxScrollExtent;
      _maxScrollExtentPadded = _maxScrollExtent - 50;

      if (_maxScrollExtent - 25 > 0) {
        if (mounted) {
          setState(() {
            _indicatorVisibility = true;
          });
        }
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _maxScrollExtentPadded) {
        if (mounted) {
          setState(() {
            _indicatorVisibility = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _indicatorVisibility = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
      mediaQueryData: MediaQuery.of(context),
    );

    final Size screenSize = screenInfo.entireScreenSize;

    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final double dialogHeight = min(450, screenSize.height * 0.80);
    final double dialogWidth = min(450, screenSize.width);

    if (screenInfo.screenType == ScreenType.tabletPortrait ||
        screenInfo.screenType == ScreenType.tabletLandscape) {
      _fontSize = 20;
      _buttonTextSize = 22;
    }

    return Align(
      alignment: Alignment.center,
      child: Container(
        height: dialogHeight,
        width: dialogWidth,
        decoration: BoxDecoration(
          color: MonAColors.darkYellow,
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: screenInfo.rightPadding +
              screenInfo.entireScreenSize.width * 0.05,
        ),
        padding: const EdgeInsets.only(left: 20, right: 10),
        child: SizedBox.expand(
          child: Material(
            child: Container(
              color: MonAColors.darkYellow,
              child: Stack(
                children: <Widget>[
                  ListView(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.only(top: 20, bottom: 20, right: 10),
                    children: <Widget>[
                      Image.asset(
                        "assets/images/ar.png",
                        width: 70,
                        height: 70,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        appLocalizations.ar_warning1,
                        style: TextStyle(
                          fontSize: _fontSize,
                          fontFamily: "cera-gr-medium",
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        appLocalizations.ar_warning2,
                        style: TextStyle(
                          fontSize: _fontSize,
                          fontFamily: "cera-gr-medium",
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // pop the dialog from the context
                          Navigator.pop(context);

                          // launch AR Game
                          await launch(
                            widget.arGameUrl,
                            enableJavaScript: true,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                appLocalizations.ar_game,
                                style: TextStyle(
                                  fontSize: _buttonTextSize,
                                  fontFamily: "cera-gr-bold",
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_rounded,
                              ),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _indicatorVisibility,
                    child: Positioned(
                      bottom: 50,
                      right: 0,
                      child: Material(
                        elevation: 8.0,
                        borderRadius: BorderRadius.circular(20),
                        child: const CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
