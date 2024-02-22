import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greenplay/services/http_overrides.dart';
import 'package:greenplay/viewmodels/composite_view_model.dart';
import 'package:greenplay/viewmodels/rental/active_rental_view_model.dart';
import 'package:greenplay/views/composite_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await Supabase.initialize(
    url: "https://vxozmpglxxygzqrifwlp.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ4b3ptcGdseHh5Z3pxcmlmd2xwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzMxOTIzNTgsImV4cCI6MTk4ODc2ODM1OH0.BhZhMYZJcXenhE3WZYohqZeGjDygook90_xpzPVlmN4",
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => CompositeViewModel())),
        ChangeNotifierProvider(create: ((context) => ActiveRentalViewModel()))
      ],
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.grey,
            primaryColor: Colors.black,
            brightness: Brightness.light,
            backgroundColor: const Color.fromARGB(255, 240, 240, 240),
            cardColor: Colors.white,
            dividerColor: const Color.fromARGB(255, 195, 195, 195),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.grey,
            primaryColor: Colors.white,
            brightness: Brightness.dark,
            backgroundColor: const Color(0xFF212121),
            cardColor: const Color.fromARGB(255, 52, 52, 52),
            dividerColor: const Color.fromARGB(255, 74, 74, 74),
          ),
          themeMode: ThemeMode.system,
          title: 'Localizations Sample App',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('de', ''), // German, no country code
          ],
          home: const CompositeView()),
    );
  }
}
