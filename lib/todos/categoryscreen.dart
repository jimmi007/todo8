import 'package:flutter/material.dart';
import 'package:todo/main.dart';

import 'package:provider/provider.dart';
import 'package:todo/models/todolist.dart';
import 'package:todo/providers/dark_theme_provider.dart';
import 'package:todo/providers/listprovider.dart';

import 'package:todo/services/utils.dart';
import 'package:todo/widgets/CatDroDownWidget.dart';

import 'package:todo/todos/newtodo.dart';
import 'package:todo/todos/todowidget.dart';
import 'package:todo/widgets/maindrawer.dart';

class Categoryscreen extends StatefulWidget {
  static const routeName = 'CategoryScreen';
  const Categoryscreen({super.key});

  @override
  State<Categoryscreen> createState() => _CategoryscreenState();
}

class _CategoryscreenState extends State<Categoryscreen> {
  @override
  void initState() {
    super.initState();

    // Load todos when the screen initializes
    Future.microtask(() {
      final listProvider = Provider.of<ListProvider>(context, listen: false);
      listProvider.loadTodos(); // Load todos asynchronously
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<ListProvider>(context);
    
    // Get the CategoryType from route arguments
    final CategoryType catValue = ModalRoute.of(context)!.settings.arguments as CategoryType;

    // Get all todos
    List<Todos> allTodos = todoProvider.getTodos.values.toList();
    
    // Get the filtered todos for the selected category
    List<Todos> getCategory = todoProvider.findByCategory(
      context, 
      catValue.getLocalizedName(context),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('All Categories')),
        actions: [
          Center(
            child: Row(
              children: [
                Catdrodownwidget(),
              ],
            ),
          ),
        ],
      ),
      drawer: const Maindrawer(),
      body: Column(
        children: [
          // If no todos are found, show a message
          getCategory.isEmpty
              ? const Center(child: Text('No Notes')) 
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: getCategory.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: getCategory[index], // Provide the todo
                        child: const Todowidget(), // Pass the todo
                      );
                    },
                  ),
                ),
          // Floating action button to add new todos
          FloatingActionButton(
            backgroundColor: kColorScheme.primaryContainer,
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
    );
  }
}
