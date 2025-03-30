import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import '../assets/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/l10n/app_localizations.dart';
//import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

import 'package:todo/main.dart';

import 'package:todo/models/Notificationservice.dart';
import 'package:todo/models/todolist.dart';
import 'package:todo/providers/listprovider.dart';
import 'package:intl/intl.dart';
import 'package:todo/todos/localeprovider.dart';
import 'package:todo/todos/newtodo.dart';
import 'package:todo/widgets/CatDroDownWidget.dart';
// Ensure this import is present

import 'package:todo/todos/todowidget.dart';
import 'package:todo/widgets/maindrawer.dart';

class Listscreen extends StatefulWidget {
  static const routeName = 'ListScreen';

  Listscreen({super.key});

  @override
  State<Listscreen> createState() => _ListscreenState();
}

class _ListscreenState extends State<Listscreen> {
  bool ischosen = true;
  bool isSelected = true;
  void initState() {
    super.initState();
    Future.microtask(() {
      final todoprovider = Provider.of<ListProvider>(context, listen: false);
      todoprovider.loadTodos(); // Load todos when screen is initialized
    });
  }

  @override
  Widget build(BuildContext context) {
    final lokProvider = Provider.of<LocaleProvider>(context, listen: false);
    Locale lok = lokProvider.locale;
    final todoprovider = Provider.of<ListProvider>(context);
    List<Todos> ontime = todoprovider.findTodosExcludingOutdate();
    List<Todos> outdate = todoprovider.findTodosOutdate();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(AppLocalizations.of(context)?.languageSwitch ?? "mid"),
        ),
        actions: const [
          Center(child: Row(children: [Catdrodownwidget()])),
        ],
      ),
      drawer: const Maindrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [SwitchListTile(
  title: Text(
    ischosen
        ? AppLocalizations.of(context)!.ondated
        : AppLocalizations.of(context)!.outdate,
  ),
  value: ischosen,
  onChanged: (bool newValue) {
    setState(() {
      ischosen = newValue; // Update the value of ischosen
    });
  },
),

            // SwitchListTile for changing the language (Greek or English)

            // SwitchListTile for another language toggle
         

            // Displaying the ListView based on the switch selection
            ischosen
                ? (ontime.isEmpty
                    ? const Center(child: Text('No ontdated duties'))
                    : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: ontime.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (DismissDirection direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                ontime.removeAt(index);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => Listscreen(),
                                  ),
                                );
                                print('Remove item');
                              }

                              setState(() {
                                todoprovider.removetodo(
                                  daytime: ontime[index].date,
                                  description: ontime[index].description,
                                  category: ontime[index].category,
                                );
                                NotificationService.cancelNotification(
                                  ontime[index].hashCode,
                                );
                              });
                            },
                            child: ChangeNotifierProvider.value(
                              value: ontime[index],
                              child: const Todowidget(),
                            ),
                          );
                        },
                      ),
                    ))
                : (outdate.isEmpty
                    ? const Center(child: Text('No outdated duties'))
                    : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: outdate.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (DismissDirection direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                outdate.removeAt(index);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => Listscreen(),
                                  ),
                                );
                                print('Remove item');
                              }

                              setState(() {
                                todoprovider.removetodo(
                                  daytime: outdate[index].date,
                                  description: outdate[index].description,
                                  category: outdate[index].category,
                                );
                                NotificationService.cancelNotification(
                                  outdate[index].hashCode,
                                );
                              });
                            },
                            child: ChangeNotifierProvider.value(
                              value: outdate[index],
                              child: const Todowidget(),
                            ),
                          );
                        },
                      ),
                    )),
            FloatingActionButton(
              backgroundColor: kColorScheme.primaryContainer,
              foregroundColor: Colors.white,
              onPressed: () {
                showModalBottomSheet(
                  useSafeArea: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) => const Newtodo(),
                );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
