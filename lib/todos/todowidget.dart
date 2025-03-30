import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/providers/listprovider.dart';
import 'package:todo/todos/tododetailsscreen.dart';

import '../models/todolist.dart';

class Todowidget extends StatefulWidget {
  const Todowidget({super.key});

  @override
  State<Todowidget> createState() => _TodowidgetState();
}

class _TodowidgetState extends State<Todowidget> {
  @override
  @override
  @override
  Widget build(BuildContext context) {
    final todoprovider = Provider.of<ListProvider>(context);
    final todosa = Provider.of<Todos>(context);
    List<Todos> alltodos = todoprovider.getTodos.values.toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            print('Navigating to details screen for ID: ${todosa.id}');
            Navigator.pushNamed(context, Tododetailsscreen.routeName,
                arguments: todosa.id);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    todosa.description,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                    overflow: TextOverflow.ellipsis, // Truncates the text
                    maxLines: 1,
                  ),

                  //Text( todosa.id, style: const TextStyle(color: Colors.black),

                  Row(
                    children: [
                      Text(
                        todosa.category.type.getLocalizedName(context), // Use extension to get the category name
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      const Spacer(),
                      Text(
                        todosa.formattedDate,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      // Display the selected date
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          //todosa.deadline.toString(),
                          todosa.deadline.getLocalizedName(context),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
