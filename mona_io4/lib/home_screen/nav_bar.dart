part of 'home_screen.dart';

BottomNavigationBar monaBottomNavigationBar(
    {required AppLocalizations appLocalizations,
    required int selectedItemIndex,
    required Function onItemTap}) {


  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: monaMaterialMagenta,
    selectedItemColor: Colors.white,
    unselectedItemColor: const Color(0xFFD8BCF9),
    unselectedLabelStyle:  const TextStyle(
        fontFamily: "cera-gr-medium"
    ),
    selectedLabelStyle: const TextStyle(
      fontFamily: "cera-gr-medium"
    ),
    currentIndex: selectedItemIndex,
    onTap: (itemIndex) {
      onItemTap(itemIndex);
    },
    items: [
      BottomNavigationBarItem(
        label: appLocalizations.museums,
        icon: const Icon(Icons.museum_outlined),
        activeIcon: const Icon(Icons.museum),
      ),
      BottomNavigationBarItem(
        label: appLocalizations.downloads,
        icon: const Icon(Icons.file_download_outlined),
        activeIcon: const Icon(Icons.file_download),
      ),
      BottomNavigationBarItem(
        label: appLocalizations.chat,
        icon: const Icon(Icons.chat_outlined),
        activeIcon: const Icon(Icons.chat),
      ),
      BottomNavigationBarItem(
        label: appLocalizations.about,
        icon: const Icon(Icons.info_outline),
        activeIcon: const Icon(Icons.info),
      ),
    ],
  );
}
