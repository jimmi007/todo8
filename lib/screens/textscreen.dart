import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/dark_theme_provider.dart';
import 'package:todo/services/utils.dart';

class Textscreen extends StatefulWidget {
  static const routeName = 'TextScreen';
  const Textscreen({super.key});

  @override
  State<Textscreen> createState() => _TextscreenState();
}

class _TextscreenState extends State<Textscreen> {
  final titleController = TextEditingController();
  String text = "No Value Entered";

  void _setText() {
    setState(() {
      text = titleController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final theme = Utils(context).getTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GeeksforGeeks'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            child: SwitchListTile(
              title: Text(
                themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
              ),
              secondary: Icon(themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              onChanged: (bool value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              },
              value: themeState.getDarkTheme,
            ), // i
          ),
          const SizedBox(
            height: 58,
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleController,
            ),
          ),
          const SizedBox(
            height: 8,
          ),

          // RaisedButton is deprecated and should not be used
          // Use ElevatedButton instead

          // RaisedButton(
          //   onPressed: _setText,
          //   child: Text('Submit'),
          //   elevation: 8,
          // ),
          const SizedBox(
            height: 20,
          ),
          Text(text),
        ],
      ),
    );
  }
}
