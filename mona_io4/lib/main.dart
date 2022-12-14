import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'colors.dart';
import 'mona_locale.dart';
import 'nav_service.dart';
import 'home_screen/home_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MonALocaleProvider>(
      create: (BuildContext providerContext) => MonALocaleProvider(),
      builder: (builderContext, child) {
        return MaterialApp(
          navigatorKey: NavigationService.mainKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "cera-gr-regular",
            primarySwatch: monaMaterialMagenta,
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          supportedLocales: MonALocale.supportedLocales,
          locale: Provider.of<MonALocaleProvider>(builderContext).locale,
          home: const AnnotatedRegion(
            value: SystemUiOverlayStyle.dark,
            child: HomeScreen(),
          ),
        );
      },
    );
  }
}
