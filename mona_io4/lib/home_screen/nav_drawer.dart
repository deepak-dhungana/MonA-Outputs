part of 'home_screen.dart';

Drawer monaNavigationDrawer(
    {required BuildContext context,
    required int selectedItemIndex,
    required Function onItemTap}) {
  final ListTileThemeData _tileThemeData = ListTileTheme.of(context).copyWith(
    iconColor: Colors.white,
    textColor: Colors.white,
    selectedColor: Colors.black,
    selectedTileColor: MonAColors.lightMagenta,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.0),
    ),
  );

  return Drawer(
    backgroundColor: monaMaterialMagenta,
    child: Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: ListView(
        // IMPORTANT: remove padding from nav drawer
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTileTheme(
                data: _tileThemeData,
                child: ListTile(
                  leading: const Icon(Icons.museum),
                  title: Text(AppLocalizations.of(context)!.museums),
                  selected: selectedItemIndex == 0,
                  onTap: () => onItemTap(0),
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTileTheme(
              data: _tileThemeData,
              child: ListTile(
                leading: const Icon(Icons.file_download),
                title: Text(AppLocalizations.of(context)!.downloads),
                selected: selectedItemIndex == 1,
                onTap: () => onItemTap(1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTileTheme(
              data: _tileThemeData,
              child: ListTile(
                leading: const Icon(Icons.chat),
                title: Text(AppLocalizations.of(context)!.chat),
                selected: selectedItemIndex == 2,
                onTap: () => onItemTap(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTileTheme(
              data: _tileThemeData,
              child: ListTile(
                leading: const Icon(Icons.info),
                title: Text(AppLocalizations.of(context)!.about),
                selected: selectedItemIndex == 3,
                onTap: () => onItemTap(3),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
