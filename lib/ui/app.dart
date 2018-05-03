import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:unsplutter/localizations.dart';
import 'package:unsplutter/ui/home.dart';

class UnsplutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ja', 'JP'),
      ],
      localizationsDelegates: [
        const UnsplutterLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
      },
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new HomeWidget(),
    );
  }
}
