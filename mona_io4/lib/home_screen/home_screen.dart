import 'package:flutter/material.dart';

import '../colors.dart';
import '../responsive_and_adaptive/screen_info.dart';

import '../chat/chat.dart';
import '../museums/museums.dart';
import '../about/about_mona.dart';
import '../downloads/downloads.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'nav_bar.dart';

part 'nav_drawer.dart';

part 'nav_rail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  // Current selected nav item
  int _currentIndex = 0;

  // Initializing the page controller
  final PageController _pageController = PageController();

  // Page key
  final GlobalKey<_HomeScreenState> _pageKey = GlobalKey<_HomeScreenState>();

  // Nav pages
  final List<Widget> _navPages = [
    const Museums(),
    const Downloads(),
    const Chat(),
    const AboutMonA(),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _pageController.dispose();
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
        return _buildBodyWithNavRail(screenInfo);

      case ScreenType.tabletPortrait:
        return _buildBodyWithNavRail(screenInfo);

      case ScreenType.tabletLandscape:
        return _buildTabletLandscapeBody();
    }
  }

  Widget _buildMobilePortraitBody() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pageViewBody(),
      bottomNavigationBar: monaBottomNavigationBar(
        appLocalizations: AppLocalizations.of(context)!,
        selectedItemIndex: _currentIndex,
        onItemTap: _onNavItemTap,
      ),
    );
  }

  Widget _buildBodyWithNavRail(ScreenInformation screenInfo) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Row(
        children: [
          monaNavigationRail(
            appLocalizations: AppLocalizations.of(context)!,
            selectedItemIndex: _currentIndex,
            onItemTap: _onNavItemTap,
            topPadding: screenInfo.topPadding,
            leftPadding: screenInfo.leftPadding,
          ),
          Expanded(child: _pageViewBody()),
        ],
      ),
    );
  }

  Widget _buildTabletLandscapeBody() {
    return Row(
      children: [
        monaNavigationDrawer(
            context: context,
            selectedItemIndex: _currentIndex,
            onItemTap: _onNavItemTap),
        Expanded(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: _pageViewBody(),
          ),
        ),
      ],
    );
  }

  // ##########################################################################

  PageView _pageViewBody() {
    return PageView(
      key: _pageKey,
      children: _navPages,
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  // ##########################################################################

  void _onNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(
        index,
      );
    });
  }
}


// ############################################################################

// WEB

// import 'package:flutter/material.dart';
//
// import '../colors.dart';
// import '../responsive_and_adaptive/screen_info.dart';
//
// import '../chat/chat.dart';
// import '../museums/museums.dart';
// import '../about/about_mona.dart';
// import '../downloads/downloads.dart';
//
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// import 'package:universal_html/html.dart' as html;
//
// part 'nav_bar.dart';
//
// part 'nav_drawer.dart';
//
// part 'nav_rail.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen>
//     with AutomaticKeepAliveClientMixin {
//   // Current selected nav item
//   int _currentIndex = 0;
//
//   // Initializing the page controller
//   final PageController _pageController = PageController();
//
//   // Page key
//   final GlobalKey<_HomeScreenState> _pageKey = GlobalKey<_HomeScreenState>();
//
//   // Nav pages
//   final List<Widget> _navPages = [
//     const Museums(),
//     const Downloads(),
//     const Chat(),
//     const AboutMonA(),
//   ];
//
//   @override
//   bool get wantKeepAlive => true;
//
//   bool _deviceTypeChecked = false;
//   bool _deviceTypeSupported = false;
//
//   @override
//   void initState() {
//     // check if the device type is supported
//     _checkDeviceType();
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final ScreenInformation screenInfo = ScreenInformation.fromMediaQueryData(
//       mediaQueryData: MediaQuery.of(context),
//     );
//
//     if (!_deviceTypeChecked) {
//       return const CircularProgressIndicator();
//     }
//
//     if (_deviceTypeChecked && !_deviceTypeSupported) {
//       return Material(
//         child: Container(
//           color: MonAColors.darkYellow,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Image.asset(
//                 "assets/images/sad_face_black.png",
//                 height: screenInfo.entireScreenSize.height * 0.30,
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Text(
//                   "Device type unsupported. Please use mobile or tablet to access the MonA web app.",
//                   style: TextStyle(fontSize: 26,
//                       fontFamily: "cera-gr-medium"),
//                   textAlign: TextAlign.center,
//                 ),
//
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return _buildBodyByScreenType(screenInfo);
//   }
//
//   Widget _buildBodyByScreenType(ScreenInformation screenInfo) {
//     switch (screenInfo.screenType) {
//       case ScreenType.mobilePortrait:
//         return _buildMobilePortraitBody();
//
//       case ScreenType.mobileLandscape:
//         return _buildBodyWithNavRail(screenInfo);
//
//       case ScreenType.tabletPortrait:
//         return _buildBodyWithNavRail(screenInfo);
//
//       case ScreenType.tabletLandscape:
//         return _buildTabletLandscapeBody();
//     }
//   }
//
//   Widget _buildMobilePortraitBody() {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: _pageViewBody(),
//       bottomNavigationBar: monaBottomNavigationBar(
//         appLocalizations: AppLocalizations.of(context)!,
//         selectedItemIndex: _currentIndex,
//         onItemTap: _onNavItemTap,
//       ),
//     );
//   }
//
//   Widget _buildBodyWithNavRail(ScreenInformation screenInfo) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       body: Row(
//         children: [
//           monaNavigationRail(
//             appLocalizations: AppLocalizations.of(context)!,
//             selectedItemIndex: _currentIndex,
//             onItemTap: _onNavItemTap,
//             topPadding: screenInfo.topPadding,
//             leftPadding: screenInfo.leftPadding,
//           ),
//           Expanded(child: _pageViewBody()),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabletLandscapeBody() {
//     return Row(
//       children: [
//         monaNavigationDrawer(
//             context: context,
//             selectedItemIndex: _currentIndex,
//             onItemTap: _onNavItemTap),
//         Expanded(
//           child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             body: _pageViewBody(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ##########################################################################
//
//   PageView _pageViewBody() {
//     return PageView(
//       key: _pageKey,
//       children: _navPages,
//       controller: _pageController,
//       physics: const NeverScrollableScrollPhysics(),
//     );
//   }
//
//   // ##########################################################################
//
//   void _onNavItemTap(int index) {
//     setState(() {
//       _currentIndex = index;
//       _pageController.jumpToPage(
//         index,
//       );
//     });
//   }
//
//   // ##########################################################################
//
//   void _checkDeviceType() async {
//     // Step 1: look if the device has touch screen
//     final int? maxTouchPoints = html.window.navigator.maxTouchPoints;
//     final bool isTouchScreen =
//     maxTouchPoints != null ? maxTouchPoints > 0 : false;
//
//     // Step 2: see for platform type
//
//     final bool isMobileDevice =
//     RegExp("Android|webOS|iPhone|iPad|iPod|BlackBerry")
//         .hasMatch(html.window.navigator.userAgent);
//
//     if (isTouchScreen && isMobileDevice) {
//       if (mounted) {
//         setState(() {
//           _deviceTypeChecked = true;
//           _deviceTypeSupported = true;
//         });
//       }
//     } else {
//       if (mounted) {
//         setState(() {
//           _deviceTypeChecked = true;
//           _deviceTypeSupported = false;
//         });
//       }
//     }
//   }
// }
