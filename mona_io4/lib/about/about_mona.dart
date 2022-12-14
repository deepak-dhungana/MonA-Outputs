import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'partner_card.dart';
import 'package:mona/colors.dart';
import 'package:mona/mona_locale.dart';
import '../responsive_and_adaptive/screen_info.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutMonA extends StatefulWidget {
  const AboutMonA({Key? key}) : super(key: key);

  @override
  _AboutMonAState createState() => _AboutMonAState();
}

class _AboutMonAState extends State<AboutMonA>
    with AutomaticKeepAliveClientMixin {
  // App type used in commission text
  static const String _appType = kIsWeb ? "web application" : "application";

  // EU commission text
  static const String _euCommissionText =
      "\"The European Commission support for the production of this $_appType "
      "does not constitute an endorsement of the contents which reflects the "
      "views only of the authors, and the Commission cannot be held "
      "responsible for any use which may be made of the information "
      "contained therein.\"";

  // MonA Locale provider
  late final MonALocaleProvider _monaLocaleProvide;

  // Pre-cached MonA Logo
  late Image monaLogo;

  // Waits a bit for first build to load partner logos
  bool _firstBuild = true;

  // Font size mapping for mobile portrait
  // Found heuristically.
  static const Map<String, double> _fontSizeMapping = {
    "en": 0.046,
    "de": 0.046,
    "el": 0.043,
    "it": 0.045,
    "nl": 0.046,
  };

  @override
  void initState() {
    super.initState();

    monaLogo = Image.asset(
      "assets/images/mona_logo.png",
      height: 80,
    );

    _monaLocaleProvide =
        Provider.of<MonALocaleProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    precacheImage(monaLogo.image, context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _monaLocaleProvide.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

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
    final Size screenSize = screenInfo.entireScreenSize;

    final double euFundedHeight = min(70, screenSize.width * 0.19);

    if (_firstBuild) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _firstBuild = false;
          });
        }
      });

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        Container(
          alignment: Alignment.centerRight,
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Language DropDown
              Padding(
                padding: EdgeInsets.only(top: screenInfo.topPadding + 20.0),
                child: Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(
                      left: screenSize.width * 0.77,
                      right: screenSize.width * 0.08),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: Localizations.localeOf(context)
                          .languageCode
                          .toUpperCase(),
                      borderRadius: BorderRadius.circular(6.0),
                      items: [
                        DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: "EN",
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/flags/us.png",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: "DE",
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/flags/at.png",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: "EL",
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/flags/gr.png",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: "IT",
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/flags/it.png",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: "NL",
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/flags/nl.png",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        _monaLocaleProvide
                            .setLocale(MonALocale.codeLocaleMapping[value]!);
                      },
                    ),
                  ),
                ),
              ),

              // Project Logo and Name
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                        child: monaLogo,
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "MonA",
                          style: TextStyle(
                            fontSize: 50,
                            color: MonAColors.darkMagenta,
                            fontFamily: "cera-gr-black",
                            height: 0.6,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Museopedagogy and\nAugmented Reality",
                          style: TextStyle(
                              fontSize: 20,
                              color: MonAColors.darkWarmRed,
                              fontFamily: "cera-gr-medium",
                              height: 0.95),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // Project Description
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 50.0),
                child: Text(
                  AppLocalizations.of(context)!.mona_info,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: screenSize.width *
                        _fontSizeMapping[
                            AppLocalizations.of(context)!.localeName]!,
                  ),
                ),
              ),

              // Project Partners
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        AppLocalizations.of(context)!
                            .partners
                            .toUpperCase(),
                        style: const TextStyle(
                          fontFamily: "cera-gr-bold",
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GridView.count(
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.5,
                      children: List.generate(
                        10,
                            (index) => MonAPartnerCard(
                          cardWidth: (screenSize.width - 10) / 2,
                          index: index,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Coordination Contact
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.contact.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "cera-gr-bold",
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.house_rounded,
                          color: monaMaterialMagenta,
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!.address,
                          style: const TextStyle(
                            fontFamily: "cera-gr-medium",
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: monaMaterialMagenta,
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        const Text(
                          "+30 24310 77977",
                          style: TextStyle(
                            fontFamily: "cera-gr-medium",
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: monaMaterialMagenta,
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        const Text(
                          "info@mouseiotsitsani.gr",
                          style: TextStyle(
                            fontFamily: "cera-gr-medium",
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.language_outlined,
                          color: monaMaterialMagenta,
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        const Text(
                          "www.monaproject.eu",
                          style: TextStyle(
                            fontFamily: "cera-gr-medium",
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // About bottom image
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  "assets/images/about_bottom.png",
                  width: screenSize.width * 0.80,
                ),
              ),

              // EU Commission Text
              Container(
                color: const Color(0xFF171718),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 8.0,
                              shadowColor: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                child: Image.asset(
                                  "assets/images/co_funded.jpg",
                                  height: euFundedHeight,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Card(
                              elevation: 8.0,
                              shadowColor: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Image.asset(
                                "assets/images/logo_greek_na.png",
                                height: euFundedHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          _euCommissionText,
                          style: TextStyle(
                            color: Color(0xFFC1FFFF),
                            fontFamily: "cera-gr-medium",
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // top status bar layer
        Container(
          width: screenSize.width,
          height: screenInfo.topPadding,
          color: Colors.white.withOpacity(0.90),
        ),
      ],
    );
  }

  Widget _buildMobileLandscapeBody(ScreenInformation screenInfo) {
    final Size screenSize = screenInfo.entireScreenSize;

    final double cardWidth =
        (screenSize.width - screenInfo.rightPadding - 20) / 2;

    if (_firstBuild) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _firstBuild = false;
          });
        }
      });

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Project Logo and Name
              Padding(
                padding: EdgeInsets.only(
                    top: 40.0,
                    left: 20.0,
                    right: screenInfo.rightPadding + 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            child: monaLogo,
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "MonA",
                              style: TextStyle(
                                fontSize: 50,
                                color: MonAColors.darkMagenta,
                                fontFamily: "cera-gr-black",
                                height: 0.6,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Museopedagogy and\nAugmented Reality",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: MonAColors.darkWarmRed,
                                  fontFamily: "cera-gr-medium",
                                  height: 0.95),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: Localizations.localeOf(context)
                              .languageCode
                              .toUpperCase(),
                          borderRadius: BorderRadius.circular(6.0),
                          alignment: AlignmentDirectional.center,
                          items: [
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "EN",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/us.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "EN",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "DE",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/at.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "DE",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: "EL",
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/flags/gr.png",
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    const Text(
                                      "EL",
                                      style: TextStyle(
                                          fontFamily: "cera-gr-medium",
                                          fontSize: 20),
                                    )
                                  ],
                                )),
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "IT",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/it.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "IT",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "NL",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/nl.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "NL",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            _monaLocaleProvide.setLocale(
                                MonALocale.codeLocaleMapping[value]!);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Project Description
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0,
                    right: screenInfo.rightPadding + 20.0,
                    top: 50.0,
                    bottom: 50.0),
                child: Text(
                  AppLocalizations.of(context)!.mona_info,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: screenSize.height * 0.045,
                  ),
                ),
              ),

              // Project Partners
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0,
                    right: screenInfo.rightPadding + 20.0,
                    top: 30.0,
                    bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.partners.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "cera-gr-bold",
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GridView.count(
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      childAspectRatio: 2.2,
                      children: List.generate(
                        10,
                            (index) => MonAPartnerCard(
                          cardWidth: cardWidth,
                          index: index,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Coordination Contact + About bottom image
              Stack(
                children: [
                  // Coordination Contact
                  Padding(
                    padding: EdgeInsets.only(
                      top: 50.0,
                      bottom: 120.0,
                      left: 20.0,
                      right: screenInfo.rightPadding + 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.contact.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: "cera-gr-bold",
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.house_rounded,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.address,
                              style: const TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            const Text(
                              "+30 24310 77977",
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            const Text(
                              "info@mouseiotsitsani.gr",
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.language_outlined,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            const Text(
                              "www.monaproject.eu",
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // About bottom image
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      "assets/images/about_bottom.png",
                      width: screenSize.width * 0.45,
                    ),
                  ),
                ],
              ),

              // EU Commission Text
              Container(
                color: const Color(0xFF171718),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 8.0,
                              shadowColor: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                child: Image.asset(
                                  "assets/images/co_funded.jpg",
                                  height: 70,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Card(
                              elevation: 8.0,
                              shadowColor: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Image.asset(
                                "assets/images/logo_greek_na.png",
                                height: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          _euCommissionText,
                          style: TextStyle(
                            color: Color(0xFFC1FFFF),
                            fontFamily: "cera-gr-medium",
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: screenSize.width,
          height: screenInfo.topPadding,
          color: Colors.white.withOpacity(0.90),
        ),
      ],
    );
  }

  Widget _buildTabletPortraitBody(ScreenInformation screenInfo) {
    final Size screenSize = screenInfo.entireScreenSize;

    final double cardWidth = (screenSize.width - 30) / 2;

    if (_firstBuild) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _firstBuild = false;
          });
        }
      });

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Project Logo and Name
              Padding(
                padding: EdgeInsets.only(
                    top: 70.0,
                    left: 50.0,
                    right: screenInfo.rightPadding + 70.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            child: monaLogo,
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "MonA",
                              style: TextStyle(
                                fontSize: 50,
                                color: MonAColors.darkMagenta,
                                fontFamily: "cera-gr-black",
                                height: 0.6,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Museopedagogy and\nAugmented Reality",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: MonAColors.darkWarmRed,
                                  fontFamily: "cera-gr-medium",
                                  height: 0.95),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: Localizations.localeOf(context)
                              .languageCode
                              .toUpperCase(),
                          borderRadius: BorderRadius.circular(6.0),
                          alignment: AlignmentDirectional.center,
                          items: [
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "EN",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/us.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "EN",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "DE",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/at.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "DE",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: "EL",
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/flags/gr.png",
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    const Text(
                                      "EL",
                                      style: TextStyle(
                                          fontFamily: "cera-gr-medium",
                                          fontSize: 20),
                                    )
                                  ],
                                )),
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "IT",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/it.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "IT",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "NL",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/nl.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "NL",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            _monaLocaleProvide.setLocale(
                                MonALocale.codeLocaleMapping[value]!);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Project Description
              Padding(
                padding: EdgeInsets.only(
                    left: 50.0,
                    right: screenInfo.rightPadding + 50.0,
                    top: 50.0,
                    bottom: 50.0),
                child: Text(
                  AppLocalizations.of(context)!.mona_info,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),

              // Project Partners
              Padding(
                padding: EdgeInsets.only(
                    left: 50.0,
                    right: screenInfo.rightPadding + 50.0,
                    top: 30.0,
                    bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.partners.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "cera-gr-bold",
                        fontSize: 26.0,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GridView.count(
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      childAspectRatio: 2.3,
                      children: List.generate(
                        10,
                        (index) => MonAPartnerCard(
                          cardWidth: cardWidth,
                          index: index,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Coordination Contact + About bottom image
              Stack(
                children: [
                  // Coordination Contact
                  Padding(
                    padding: EdgeInsets.only(
                        left: 50.0,
                        right: screenInfo.rightPadding + 50.0,
                        top: 50.0,
                        bottom: 200.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.contact.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: "cera-gr-bold",
                            fontSize: 26.0,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.house_rounded,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.address,
                              style: const TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            const Text(
                              "+30 24310 77977",
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            const Text(
                              "info@mouseiotsitsani.gr",
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.language_outlined,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            const Text(
                              "www.monaproject.eu",
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // About bottom image
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      "assets/images/about_bottom.png",
                      width: screenSize.width * 0.45,
                    ),
                  ),
                ],
              ),

              // EU Commission Text
              Container(
                color: const Color(0xFF171718),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 8.0,
                              shadowColor: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                child: Image.asset(
                                  "assets/images/co_funded.jpg",
                                  height: 70,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Card(
                              elevation: 8.0,
                              shadowColor: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Image.asset(
                                "assets/images/logo_greek_na.png",
                                height: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                        child: Text(
                          _euCommissionText,
                          style: TextStyle(
                            color: Color(0xFFC1FFFF),
                            fontFamily: "cera-gr-medium",
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: screenSize.width,
          height: screenInfo.topPadding,
          color: Colors.white.withOpacity(0.90),
        ),
      ],
    );
  }

  Widget _buildTabletLandscapeBody(ScreenInformation screenInfo) {
    final Size screenSize = screenInfo.entireScreenSize;

    final double cardWidth = (screenSize.width - 20) / 3;

    if (_firstBuild) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _firstBuild = false;
          });
        }
      });

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [

              // Project Logo and Name
              Padding(
                padding: EdgeInsets.only(
                    top: 70.0,
                    left: 50.0,
                    right: screenInfo.rightPadding + 70.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            child: monaLogo,
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "MonA",
                              style: TextStyle(
                                fontSize: 50,
                                color: MonAColors.darkMagenta,
                                fontFamily: "cera-gr-black",
                                height: 0.6,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Museopedagogy and\nAugmented Reality",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: MonAColors.darkWarmRed,
                                  fontFamily: "cera-gr-medium",
                                  height: 0.95),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: Localizations.localeOf(context)
                              .languageCode
                              .toUpperCase(),
                          borderRadius: BorderRadius.circular(6.0),
                          alignment: AlignmentDirectional.center,
                          items: [
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "EN",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/us.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "EN",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "DE",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/at.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "DE",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: "EL",
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/flags/gr.png",
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    const Text(
                                      "EL",
                                      style: TextStyle(
                                          fontFamily: "cera-gr-medium",
                                          fontSize: 20),
                                    )
                                  ],
                                )),
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "IT",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/it.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "IT",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: "NL",
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/flags/nl.png",
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  const Text(
                                    "NL",
                                    style: TextStyle(
                                        fontFamily: "cera-gr-medium",
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            _monaLocaleProvide.setLocale(
                                MonALocale.codeLocaleMapping[value]!);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Project Description
              Padding(
                padding: EdgeInsets.only(
                    left: 50.0,
                    right: screenInfo.rightPadding + 50.0,
                    top: 50.0,
                    bottom: 50.0),
                child: Text(
                  AppLocalizations.of(context)!.mona_info,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),

              // Project Partners
              Padding(
                padding: EdgeInsets.only(
                    left: 50.0,
                    right: screenInfo.rightPadding + 50.0,
                    top: 30.0,
                    bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.partners.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "cera-gr-bold",
                        fontSize: 26.0,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GridView.count(
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 2,
                      children: List.generate(
                        10,
                        (index) => MonAPartnerCard(
                          cardWidth: cardWidth,
                          index: index,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Coordination Contact + About bottom image
              Stack(
                children: [
                  // Coordination Contact
                  Padding(
                    padding: EdgeInsets.only(
                        left: 50.0,
                        right: screenInfo.rightPadding + 50.0,
                        top: 50.0,
                        bottom: 170.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.contact.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: "cera-gr-bold",
                            fontSize: 26.0,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.house_rounded,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.address,
                              style: const TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            const Text(
                              "+30 24310 77977",
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            const Text(
                              "info@mouseiotsitsani.gr",
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.language_outlined,
                              color: monaMaterialMagenta,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            const Text(
                              "www.monaproject.eu",
                              style: TextStyle(
                                fontFamily: "cera-gr-medium",
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // About bottom image
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      "assets/images/about_bottom.png",
                      width: screenSize.width * 0.35,
                    ),
                  ),
                ],
              ),

              // EU Commission Text
              Container(
                color: const Color(0xFF171718),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 8.0,
                              shadowColor: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                child: Image.asset(
                                  "assets/images/co_funded.jpg",
                                  height: 70,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Card(
                              elevation: 8.0,
                              shadowColor: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Image.asset(
                                "assets/images/logo_greek_na.png",
                                height: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100.0, vertical: 20.0),
                        child: Text(
                          _euCommissionText,
                          style: TextStyle(
                            color: Color(0xFFC1FFFF),
                            fontFamily: "cera-gr-medium",
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: screenSize.width,
          height: screenInfo.topPadding,
          color: Colors.white.withOpacity(0.90),
        ),
      ],
    );
  }
}
