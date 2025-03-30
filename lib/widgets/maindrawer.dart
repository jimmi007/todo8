import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/l10n/app_localizations.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart;
import 'package:todo/main.dart';
import 'package:todo/notes/note_screen.dart';
import 'package:todo/providers/dark_theme_provider.dart';
import 'package:todo/services/utils.dart';
import 'package:todo/todos/listscreen.dart';
import 'package:todo/todos/localeprovider.dart';
import 'package:todo/todos/tododetailsscreen.dart';

class Maindrawer extends StatefulWidget {
  const Maindrawer({super.key});

  @override
  State<Maindrawer> createState() => _MaindrawerState();
}

class _MaindrawerState extends State<Maindrawer> {
  int selectedindex = 0;
  void onitemTapped(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  bool isChosen = true;

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final theme = Utils(context).getTheme;
    final lokProvider = Provider.of<LocaleProvider>(context, listen: false);
    Locale lok = lokProvider.locale;
    return Drawer(width:size.width*0.65 ,
      backgroundColor:
          theme
              ? kDarkColorScheme.secondaryContainer
              : kColorScheme.primaryContainer,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient:
                  theme
                      ? LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.secondaryContainer,
                          Theme.of(
                            context,
                          ).colorScheme.secondaryContainer.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.96),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
            ),
            child: Text(
              'Choose an option',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => Tododetailsscreen()));
            },
            child: ListTile(
              title: Text(
              AppLocalizations.of(context)!.hobbies,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                Icons.arrow_downward,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => NoteScreen()));
            },
            child: ListTile(
              title: Text(
                AppLocalizations.of(context)!.hello,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                Icons.arrow_downward,
                size: 26,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SwitchListTile(
  title: Text(AppLocalizations.of(context)!.languageSwitch),
  value: lok.languageCode == 'en', // Check current locale
  onChanged: (bool newValue) {
    final newLocale = newValue ? const Locale('en') : const Locale('el');
    lokProvider.setLocale(newLocale);
  },
),

          SwitchListTile(
            title: Text(themeState.getDarkTheme ? 'Dark mode' : 'Light mode'),
            secondary: Icon(
              themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            onChanged: (bool value) {
              setState(() {
                themeState.setDarkTheme = value;
              });
            },
            value: themeState.getDarkTheme,
          ),
        ],
      ),
    );
  }
}
