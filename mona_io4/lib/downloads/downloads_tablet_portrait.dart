part of 'downloads.dart';

Widget _downloadsTabletPortrait(
    {required ScreenInformation screenInfo,
    required AppLocalizations appLocalizations,
    required List fileNames}) {
  // since tablet portrait mode
  final safeAreaPadding = EdgeInsets.only(
    right: screenInfo.rightPadding,
  );

  return LayoutBuilder(builder: (lbContext, lbConstraints) {
    final availableHeight = lbConstraints.maxHeight;
    final availableWidth = lbConstraints.maxWidth;

    final cardWidth = availableHeight * 0.30;
    final cardHeight = cardWidth * 0.60;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: safeAreaPadding,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
            vertical: availableHeight * 0.04,
          ),
          itemCount: fileNames.length + 1,
          itemBuilder: (itemContext, index) {
            // add Header for index 0
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: availableWidth * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizations.downloads,
                      style: TextStyle(
                        fontSize: availableHeight * 0.035,
                        fontFamily: "cera-gr-bold",
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.black38,
                    )
                  ],
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: availableWidth * 0.05,
                  ),
                  child: Row(
                    children: [
                      Text(
                        fileNames[index - 1][0],
                        style: const TextStyle(
                            fontFamily: "cera-gr-medium",
                            fontSize: 20,
                            color: Colors.black87),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Image.asset(
                        "assets/flags/${fileNames[index - 1][2]}.png",
                        height: 18,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: cardHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.symmetric(
                      horizontal: availableWidth * 0.05,
                    ),
                    itemBuilder: (itemContext, idx) {
                      return DownloadsCard(
                        pdfFile: fileNames[index - 1][1][idx],
                        cardHeight: cardHeight,
                        cardWidth: cardWidth,
                        colorIndex: index - 1,
                      );
                    },
                    separatorBuilder: (separatorContext, idx2) {
                      return SizedBox(
                        width: availableWidth * 0.02,
                      );
                    },
                    itemCount: fileNames[index - 1][1].length,
                  ),
                ),
                index < fileNames.length
                    ? Padding(
                  padding: EdgeInsets.only(
                      left: availableWidth * 0.05,
                      right: availableWidth * 0.05,
                      top: availableHeight * 0.02
                  ),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.shade400,
                  ),
                )
                    : SizedBox(
                  height: availableHeight * 0.03,
                ),
              ],
            );
          },
          separatorBuilder: (separatorContext, index) {
            if (index == 0) {
              return SizedBox(
                height: availableHeight * 0.02,
              );
            }
            return SizedBox(
              height: availableHeight * 0.03,
            );
          },
        ),
      ),
    );
  });
}
