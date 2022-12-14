part of 'downloads.dart';

Widget _downloadsMobilePortrait(
    {required ScreenInformation screenInfo,
    required AppLocalizations appLocalizations,
    required List fileNames,
    required TabController tabController}) {
  return LayoutBuilder(builder: (lbContext, lbConstraints) {
    final availableHeight = lbConstraints.maxHeight;
    final availableWidth = lbConstraints.maxWidth;

    final cardWidth = availableWidth * 0.90;
    final cardHeight = cardWidth * 0.575;

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/screen_background/downloads_mobile_portrait.png",
              ),
              fit: BoxFit.cover)),
      child: Padding(
        padding: EdgeInsets.only(
          top: screenInfo.topPadding + (availableHeight * 0.01),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                appLocalizations.downloads,
                style: TextStyle(
                  fontSize: availableHeight * 0.045,
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
                      )),
              padding: const EdgeInsets.all(10.0),
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: MonAColors.lightGreen),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: List.generate(
                  fileNames.length,
                  (idx1) => ListView.separated(
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.only(top: 10, bottom: 30),
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
                        height: availableHeight * 0.02,
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
