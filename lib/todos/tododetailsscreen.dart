import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/main.dart';
import 'package:todo/models/todolist.dart';
import 'package:todo/providers/listprovider.dart';

class Tododetailsscreen extends StatefulWidget {
  static const routeName = 'Tododetailsscreen';
  const Tododetailsscreen({super.key});

  @override
  State<Tododetailsscreen> createState() => _TododetailsscreenState();
}

class _TododetailsscreenState extends State<Tododetailsscreen> {
  late TextEditingController destext;
  late TextEditingController datetext;
  String? errortext;
  DateTime? selectedDate;
  String? selectedCategory;
  var existingTodo;
  @override
  void initState() {
    super.initState();
    destext = TextEditingController();
    datetext = TextEditingController();

    // Delay initialization until after the build context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final todoProvider = Provider.of<ListProvider>(context, listen: false);

      final todoid = ModalRoute.of(context)!.settings.arguments as String;
      final gettodos = todoProvider.findTodoById(todoid);
      List<Todos> alltodos = todoProvider.getTodos.values.toList();

      if (gettodos != null) {
        setState(() {
          existingTodo = gettodos;
          destext = TextEditingController(text: gettodos.description);
          datetext = TextEditingController(text: gettodos.formattedDate);
          selectedCategory = gettodos.category.type.toString().split('.').last;
          selectedDate = gettodos.date;
        });
      }
    });
  }

  @override
  void dispose() {
    destext.dispose();
    datetext.dispose();
    super.dispose();
  }

  void _presentDayPicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    var pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        datetext.text = pickedDate.toIso8601String().split('T').first;
      });
    }
  }

  CategoryType? _getCategoryTypeFromString(String? categoryStr) {
    if (categoryStr == null) return null;
    switch (categoryStr.toLowerCase()) {
      case 'hobbies':
        return CategoryType.hobbies;
      case 'obligations':
        return CategoryType.obligations;
      case 'travels':
        return CategoryType.travels;
      case 'various':
        return CategoryType.various;
      default:
        return null;
    }
  }

  void _updateTodo() {
    if (destext.text.trim().isEmpty ||
        selectedDate == null ||
        destext.text.length > 20 ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ένα απο τα πεδία δεν έχουν συμπληρωθεί σωστά'),
        ),
      );
      return;
    }

    final updatedTodo = Todos(
      id: existingTodo.id,
      description: destext.text.trim(),
      date: selectedDate ?? existingTodo.date,
      category: Category(
          type: _getCategoryTypeFromString(selectedCategory) ??
              existingTodo.category.type),
      deadline: existingTodo.deadline,
      isCompleted: existingTodo.isCompleted,
    );

    final todoProvider = Provider.of<ListProvider>(context, listen: false);
    todoProvider.updateTodo(existingTodo.id, updatedTodo);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Η υπενθύμιση ενημερώθηκε με επιτυχία'),
      ),
    );
    Navigator.of(context).pop();
  }

  // Delay navigation to allow SnackBar to be visible before popping

  // Pop the current screen and go back to the list screen

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<ListProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Todo Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: destext,
                enableSuggestions: true,
                decoration: InputDecoration(
                  labelText: 'Titles',
                  border: const UnderlineInputBorder(),
                  errorText: errortext,
                  errorStyle: const TextStyle(color: Colors.red),
                  counterText: '',
                ),
                onChanged: (value) {
                  setState(() {
                    errortext = destext.text.length > 20
                        ? 'Το όριο χαρακτήρων προσπεράστηκε'
                        : null;
                  });
                }),
            const SizedBox(height: 12),
            Text(
              existingTodo.id,
              style: const TextStyle(color: Colors.black),
            ),
            DropdownButton<String>(
              value: selectedCategory,
              dropdownColor: kColorScheme.secondary,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              items: ['hobbies', 'obligations', 'travels', 'various']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: datetext,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Date'),
                  ),
                ),
                IconButton(
                  onPressed: _presentDayPicker,
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateTodo();
              },
              child: const Text('Update Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
