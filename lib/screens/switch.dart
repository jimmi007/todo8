import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/dark_theme_provider.dart';

class Switch extends StatefulWidget {
  const Switch({super.key});

  @override
  State<Switch> createState() => _SwitchState();
}

class _SwitchState extends State<Switch> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return Center(
      child: Container(
        child: SwitchListTile(
            title: Text(
              themeProvider.getDarkTheme ? 'Dark' : 'Light',
              style: const TextStyle(fontSize: 20),
            ),
            secondary: Icon(
              themeProvider.getDarkTheme ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.secondary,
            ),
            value: themeProvider.getDarkTheme,
            onChanged: (bool value) {
              setState(() {
                themeProvider.setDarkTheme = value;
              });
            }),
      ),
    );
  }
}
