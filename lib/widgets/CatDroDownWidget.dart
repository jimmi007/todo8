import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/main.dart';
import 'package:todo/models/todolist.dart';
import 'package:todo/providers/listprovider.dart';
import 'package:todo/todos/categoryscreen.dart';
import 'package:todo/l10n/app_localizations.dart';
class Catdrodownwidget extends StatefulWidget {
  const Catdrodownwidget({super.key});

  @override
  _CatDropDownWidgetState createState() => _CatDropDownWidgetState();
}

class _CatDropDownWidgetState extends State<Catdrodownwidget> {
  CategoryType? _catValue;

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<ListProvider>(context);
    List<Todos> allTodos = todoProvider.getTodos.values.toList();
    List<Todos> getCategory = [];
    if (_catValue != null) {
      getCategory = todoProvider.findByCategory(context ,  _catValue!.getLocalizedName(context));

    }

    // Extract categories from the todos
    List<String> categories = allTodos
        .map((todo) => todo.category.type.toString().split('.').last)
        .toList();
    List<String> categories1 = [
      'hobbies',
      'obligations',
      'travels',
      'various '
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton<CategoryType>(
        style: const TextStyle(color: Colors.white), // Set text color
        hint: Text(
          _catValue == null
              ? AppLocalizations.of(context)!.categorise
              : _catValue!.getLocalizedName(context),
          style: const TextStyle(color: Colors.white),
        ), // Localized hint
        value: _catValue,
        dropdownColor: kColorScheme.primaryContainer,
        items: CategoryType.values.map((category) {
          return DropdownMenuItem<CategoryType>(
            value: category,
            child: Text(
              category.getLocalizedName(context),
              style: TextStyle(color: kColorScheme.onPrimaryContainer),
            ),
          );
        }).toList(),
        onChanged: (CategoryType? value) {
  if (value == null) return; // If the selected value is null, return early

  setState(() {
    _catValue = value; // Update the selected category
    // Call findByCategory with the localized name and context
    todoProvider.findByCategory(context, value.getLocalizedName(context));
    // Navigate to the Category screen with the selected category as an argument
    Navigator.pushNamed(
      context,
      Categoryscreen.routeName,
      arguments: _catValue, // Passing the selected category
    );
  });
},

      ),
    );
  }
}