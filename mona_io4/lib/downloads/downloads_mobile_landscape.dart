part of 'downloads.dart';

Widget _downloadsMobileLandscape(
    {required ScreenInformation screenInfo,
    required AppLocalizations appLocalizations,
    required List fileNames,
    required TabController tabController}) {
  return LayoutBuilder(builder: (lbContext, lbConstraints) {
    final availableHeight = lbConstraints.maxHeight;
    final availableWidth = lbConstraints.maxWidth;

    final cardHeight = availableHeight * 0.60 - screenInfo.topPadding;
    final cardWidth = cardHeight * 1.60;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/screen_background/downloads_mobile_landscape.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: availableHeight * 0.03 + screenInfo.topPadding,
            bottom: screenInfo.bottomPadding + 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                appLocalizations.downloads,
                style: TextStyle(
                  fontSize: availableHeight * 0.08,
                  fontFamily: "cera-gr-bold",
                ),
              ),
            ),
            TabBar(
              controller: tabController,
              isScrollable: true,
              unselectedLabelColor: Colors.black,
              labelColor: monaMaterialGreen,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontFamily: "cera-gr-medium",
              ),
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
              tabs: List.generate(
                fileNames.length,
                (index) => Text(
                  fileNames[index][0],
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: MonAColors.lightGreen),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: List.generate(
                  fileNames.length,
                  (idx1) => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.only(
                        left: 10.0, right: screenInfo.rightPadding + 20.0),
                    itemBuilder: (itemContext, idx2) {
                      return DownloadsCard(
                        pdfFile: fileNames[idx1][1][idx2],
                        cardHeight: cardHeight,
                        cardWidth: cardWidth,
                        colorIndex: idx1,
                      );
                    },
                    separatorBuilder: (separatorContext, idx2) {
                      return SizedBox(
                        width: availableWidth * 0.02,
                      );
                    },
                    itemCount: fileNames[idx1][1].length,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  });
}
