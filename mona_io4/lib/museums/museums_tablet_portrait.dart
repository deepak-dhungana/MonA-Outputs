part of 'museums.dart';

Widget _museumTabletPortrait(
    {required BuildContext context,
    required ScrollController listViewController,
    required ScreenInformation screenInfo,
    required List<String> folderNames}) {
  // since tablet portrait mode
  final safeAreaPadding = EdgeInsets.only(
    right: screenInfo.rightPadding,
  );

  return LayoutBuilder(builder: (lbContext, lbConstraints) {
    final availableHeight = lbConstraints.maxHeight;
    final availableWidth = lbConstraints.maxWidth;

    return Container(
      color: MonAColors.screenBackgroundColor,
      child: Padding(
        padding: safeAreaPadding,
        child: ListView.separated(
          controller: listViewController,
          padding: EdgeInsets.symmetric(
            horizontal: availableWidth * 0.05,
            vertical: availableHeight * 0.04,
          ),
          itemCount: folderNames.length + 1,
          itemBuilder: (itemContext, index) {
            // add Header for index 0
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.museums,
                    style:  TextStyle(
                      fontSize: availableHeight * 0.035,
                      fontFamily: "cera-gr-bold",
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.black38,
                  )
                ],
              );
            }

            return MuseumCard(
              museumFolderName: folderNames[index - 1],
            );
          },
          separatorBuilder: (separatorContext, index) {
            if(index == 0){

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
