part of 'museums.dart';

Widget _museumMobileLandscape(
    {required BuildContext context,
    required GlobalKey pageKey,
    required ScreenInformation screenInfo,
    required PageController pageController,
    required List<String> folderNames}) {
  // since mobile landscape mode
  final safeAreaPadding = EdgeInsets.only(
    top: screenInfo.topPadding,
    bottom: screenInfo.bottomPadding,
    right: screenInfo.rightPadding,
  );

  return LayoutBuilder(builder: (lbContext, lbConstraints) {
    final availableWidth = lbConstraints.maxWidth;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/screen_background/museums_mobile_landscape.png"),
            fit: BoxFit.cover
        ),
      ),
      child: Padding(
        padding: safeAreaPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: availableWidth * .01,
            ),
            Expanded(
              child: PageView(
                key: pageKey,
                controller: pageController,
                clipBehavior: Clip.none,
                scrollDirection: Axis.vertical,
                children: List.generate(
                  folderNames.length,
                      (int folderNameIndex) => MuseumCard(
                    museumFolderName: folderNames[folderNameIndex],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: availableWidth * .01,
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: folderNames.length,
              axisDirection: Axis.vertical,
              effect: ScrollingDotsEffect(
                dotHeight: availableWidth * 0.01,
                dotWidth: availableWidth * 0.01,
                radius: 12.0,
                spacing: 12.0,
                activeDotColor: monaMaterialMagenta,
              ),
            ),
            SizedBox(
              width: availableWidth * .02,
            ),
          ],
        ),
      ),
    );
  });
}
