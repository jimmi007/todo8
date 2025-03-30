import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/Notificationservice.dart';
import 'package:todo/models/todolist.dart';

class ListProvider with ChangeNotifier {
  static const String _TodoKey = 'Todo_key';
  Map<String, Todos> _TodoMap = {};

  Map<String, Todos> get getTodos => _TodoMap;

  Future<void> loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString(_TodoKey);

    if (todosString != null) {
      try {
        Map<String, dynamic> todosJson = json.decode(todosString);
        _TodoMap = todosJson.map((key, value) => MapEntry(
              key,
              Todos.fromJson(value as Map<String, dynamic>),
            ));
      } catch (e) {
        print("Error decoding todos: $e");
        _TodoMap = {};
      }
    } else {
      _TodoMap = {};
    }
    notifyListeners();
  }

  Future<void> _saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedTodos = json.encode(
        _TodoMap.map((key, value) => MapEntry(key, value.toJson())));
    await prefs.setString(_TodoKey, encodedTodos);
  }

  Future<void> addTodo(Todos todo) async {
    if (todo.id.isEmpty) {
      todo = Todos(
        id: uuid.v4(),
        description: todo.description,
        date: todo.date,
        category: todo.category,
        isCompleted: todo.isCompleted,
        deadline: _categorizeDeadline(todo.date),
      );
    }

    _TodoMap[todo.id] = todo;
    await _saveTodos();
    notifyListeners();
  }

  Future<void> removetodo(
      {required String description,
      required DateTime daytime,
      required Category category}) async {
    String? keyToRemove;

    // Find the correct key by matching the description, date, and category
    _TodoMap.forEach((key, value) {
      if (value.description == description &&
          value.date == daytime &&
          value.category == category) {
        keyToRemove = key;
      }
    });

    if (keyToRemove != null) {
      _TodoMap.remove(keyToRemove);
      print('Updated list after removal: $_TodoMap');
      await _saveTodos();
      notifyListeners();
    } else {
      print('Todo not found for removal');
    }
  }

  // Save Todos to SharedPreferences

  // Update a todo
// Update a todo
  void updateTodo(String id, Todos updatedTodo) {
    if (_TodoMap.containsKey(id)) {
      _TodoMap[id] = updatedTodo;
      print('Updated list after update: $_TodoMap'); // Debugging print
      _saveTodos();
      notifyListeners(); // Ensure this triggers the UI rebuild
    } else {
      print('Todo not found for update: $id');
      print('Current keys in _TodoMap: ${_TodoMap.keys}');
    }
  }
  List<Todos> findTodosExcludingOutdate() {
    return _TodoMap.values
        .where((todo) => todo.deadline != Deadline.thisdate)
        .toList();
  }

  List<Todos> findTodosOutdate() {
    return _TodoMap.values
        .where((todo) => todo.deadline == Deadline.thisdate)
        .toList();
  }

  // Search Todos
  List<Todos> searchTodos(String searchText) {
    return _TodoMap.values
        .where(
          (todo) =>
              todo.description.toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();
  }

  // Find a todo by ID
  Todos? findTodoById(String id) {
    return _TodoMap[id];
  }
  List<Todos> findByCategory(BuildContext context, String categoryName) {
    return _TodoMap.values.where((todo) =>
        todo.category.type.getLocalizedName(context).toLowerCase() == categoryName.toLowerCase()).toList();
  }

  List<Todos> findByDeadline(Deadline deadline) {
    return _TodoMap.values.where((todo) => todo.deadline == deadline).toList();
  }

  static Deadline _categorizeDeadline(DateTime selectedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final oneMonthLater = today.add(const Duration(days: 30));
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (selectedDay.isBefore(today)) return Deadline.outdate;
    if (selectedDay.isAtSameMomentAs(today)) return Deadline.thisdate;
    if (selectedDay.isBefore(oneMonthLater)) return Deadline.thismonth;
    return Deadline.later;
  }
}
