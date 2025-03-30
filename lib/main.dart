import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/l10n/l10n.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/models/Notificationservice.dart';
import 'package:todo/notes/new_note.dart';
import 'package:todo/notes/note_details.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:todo/notes/note_screen.dart';
// Ensure this import is present
import 'package:todo/l10n/app_localizations.dart';
// Add this import
// Adjust import
import 'package:todo/providers/dark_theme_provider.dart';
import 'package:todo/providers/listprovider.dart';
import 'package:todo/providers/noteprovider.dart';

import 'package:todo/todos/categoryscreen.dart';

import 'package:todo/todos/listscreen.dart';
import 'package:todo/todos/localeprovider.dart';
import 'package:todo/todos/tododetailsscreen.dart';
//import "flutter_gen/gen_l10n/app_localizations.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final todoprovider = ListProvider();
  await todoprovider.loadTodos();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Athens')); // Set correct timezone

  await NotificationService.initNotification();

  runApp(const MyApp());
}

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF28638a));
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFFb6c4ff),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeChangeProvider),
        ChangeNotifierProvider(create: (_) => ListProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<DarkThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',

            // Language settings
            locale: localeProvider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: AppLocalizations.localizationsDelegates,

            // Theme settings
            themeMode:
                themeProvider.getDarkTheme ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData().copyWith(
              colorScheme: kColorScheme.copyWith(brightness: Brightness.light),
              scaffoldBackgroundColor: kColorScheme.primaryContainer,
              appBarTheme: AppBarTheme(
                backgroundColor: kColorScheme.primaryContainer,
                elevation: 0.2,
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: kDarkColorScheme.copyWith(
                brightness: Brightness.dark,
              ),
                elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
            foregroundColor: Colors.white,
          ),
        ),
              scaffoldBackgroundColor: kDarkColorScheme.primaryContainer,
              appBarTheme: AppBarTheme(
                backgroundColor: kDarkColorScheme.primaryContainer,
                foregroundColor: kDarkColorScheme.onPrimaryContainer,
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Routes
            routes: {
              Listscreen.routeName: (context) => Listscreen(),
              Tododetailsscreen.routeName:
                  (context) => const Tododetailsscreen(),
              Notedetails.routeName: (context) => const Notedetails(),
              NoteScreen.routeName: (context) => const NoteScreen(),
              NewNote.routeName: (context) => const NewNote(),
              Categoryscreen.routeName: (context) => const Categoryscreen(),
            },

            // Initial screen
            home: Listscreen(),
          );
        },
      ),
    );
  }
}
