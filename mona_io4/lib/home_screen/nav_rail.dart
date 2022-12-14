part of 'home_screen.dart';

Widget monaNavigationRail(
    {required AppLocalizations appLocalizations,
    required int selectedItemIndex,
    required Function onItemTap,
    required double topPadding,
    required double leftPadding}) {
  return Material(
    elevation: 16.0,
    child: Row(
      children: [
        Container(
          width: leftPadding,
          color: monaMaterialMagenta,
        ),
        NavigationRail(
          backgroundColor: monaMaterialMagenta,
          unselectedIconTheme: const IconThemeData(color: Color(0xFFd8bcf9)),
          unselectedLabelTextStyle: const TextStyle(color: Color(0xFFd8bcf9)),
          selectedIconTheme: const IconThemeData(color: Colors.white),
          selectedLabelTextStyle: const TextStyle(color: Colors.white),
          selectedIndex: selectedItemIndex,
          onDestinationSelected: (itemIndex) {
            onItemTap(itemIndex);
          },
          labelType: NavigationRailLabelType.all,
          destinations: [
            NavigationRailDestination(
              padding: EdgeInsets.only(top: topPadding + 10.0),
              label: Text(appLocalizations.museums),
              icon: const Icon(Icons.museum_outlined),
              selectedIcon: const Icon(Icons.museum),
            ),
            NavigationRailDestination(
              label: Text(appLocalizations.downloads),
              icon: const Icon(Icons.file_download_outlined),
              selectedIcon: const Icon(Icons.file_download),
            ),
            NavigationRailDestination(
              label: Text(appLocalizations.chat),
              icon: const Icon(Icons.chat_outlined),
              selectedIcon: const Icon(Icons.chat),
            ),
            NavigationRailDestination(
              label: Text(appLocalizations.about),
              icon: const Icon(Icons.info_outline),
              selectedIcon: const Icon(Icons.info),
            ),
          ],
        )
      ],
    ),
  );
}
