import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/providers/dark_theme_provider.dart';

class Utils {
  BuildContext context;
  Utils(this.context);
  bool get getTheme => Provider.of<DarkThemeProvider>(context).getDarkTheme;

  Size get getScreenSize => MediaQuery.of(context).size;
  ThemeMode get themeMode => getTheme ? ThemeMode.light : ThemeMode.dark;
  Brightness get brightness => getTheme ? Brightness.light : Brightness.dark;
}
