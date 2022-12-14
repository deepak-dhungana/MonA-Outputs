part of 'museums.dart';

Widget _museumMobilePortrait(
    {required BuildContext context,
    required GlobalKey pageKey,
    required ScreenInformation screenInfo,
    required PageController pageController,
    required List<String> folderNames}) {
  // since mobile portrait mode
  final safeAreaPadding = EdgeInsets.only(
    top: screenInfo.topPadding,
  );

  return LayoutBuilder(builder: (lbContext, lbConstraints) {
    final availableHeight = lbConstraints.maxHeight;
    final availableWidth = lbConstraints.maxWidth;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/screen_background/museums_mobile_portrait.png"),
          fit: BoxFit.cover
        ),
      ),
      child: Padding(
      padding: safeAreaPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: availableHeight * .01,
          ),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: availableWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.museums,
                  style: TextStyle(
                    fontSize: availableHeight * 0.045,
                    fontFamily: "cera-gr-bold",
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.black45,
                )
              ],
            ),
          ),
          SizedBox(
            height: availableHeight * .01,
          ),

          // portrait card section. Height: availableHeight * 0.75
          Expanded(
            child: PageView(
              key: pageKey,
              controller: pageController,
              clipBehavior: Clip.none,
              children: List.generate(
                folderNames.length,
                    (int folderNameIndex) => MuseumCard(
                  museumFolderName: folderNames[folderNameIndex],
                ),
              ),
            ),
          ),
          SizedBox(
            height: availableHeight * .02,
          ),
          SmoothPageIndicator(
            controller: pageController,
            count: folderNames.length,
            effect: ScrollingDotsEffect(
              dotHeight: availableHeight * 0.01,
              dotWidth: availableHeight * 0.01,
              radius: 12.0,
              spacing: 12.0,
              activeDotColor: monaMaterialMagenta,
            ),
          ),
          SizedBox(
            height: availableHeight * .02,
          ),
        ],
      ),
    ),);
  });
}
