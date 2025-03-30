import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/main.dart';
import 'package:todo/models/Notificationservice.dart';
import 'package:todo/models/todolist.dart';
import 'package:todo/providers/listprovider.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/models/Notificationservice.dart';
import 'package:todo/models/todolist.dart';
import 'package:todo/providers/listprovider.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/models/Notificationservice.dart';
import 'package:todo/models/todolist.dart';
import 'package:todo/providers/listprovider.dart';
import 'package:uuid/uuid.dart';

class Newtodo extends StatefulWidget {
  const Newtodo({super.key});

  @override
  State<Newtodo> createState() => _NewtodoState();
}

class _NewtodoState extends State<Newtodo> {
  final dsrcontroller = TextEditingController();
  DateTime? selectedDate;
  String? _catValue;
  String? errortext;
CategoryType? _selectedCategory;
  void dispose() {
    dsrcontroller.dispose();
    super.dispose();
  }

  Deadline deadlineCategorize(DateTime selectedDate) {
    final now = DateTime.now();
    final nowDate = DateTime(now.year, now.month, now.day);
    final selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final oneMonthLater = nowDate.add(const Duration(days: 30));

    if (selectedDateOnly.isBefore(nowDate)) {
      return Deadline.outdate;
    } else if (selectedDateOnly.isAtSameMomentAs(nowDate)) {
      return Deadline.thisdate;
    } else if (selectedDateOnly.isBefore(oneMonthLater)) {
      return Deadline.thismonth;
    } else {
      return Deadline.later;
    }
  }

  @override
  void _presentDayPicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: lastDate,
    );

    if (pickedDate == null) return;

    DateTime fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
    );

    setState(() {
      selectedDate = fullDateTime;
    });

    debugPrint("Selected Date-Time: $selectedDate");
  }

   Future<void> submitTodo() async {
    var uuid = Uuid();
    final todoprovider = Provider.of<ListProvider>(context, listen: false);

    if (dsrcontroller.text.trim().isEmpty ||
        selectedDate == null ||
        _selectedCategory == null ||
        dsrcontroller.text.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ένα από τα πεδία δεν έχουν συμπληρωθεί σωστά'),
        ),
      );
      return;
    }
   
    CategoryType categoryType;
    switch (_catValue) {
      case 'hobbies':
        categoryType = CategoryType.hobbies;
        break;
      case 'obligations':
        categoryType = CategoryType.obligations;
        break;
      case 'travels':
        categoryType = CategoryType.travels;
        break;
      case 'various':
        categoryType = CategoryType.various;
        break;
      default:
        categoryType = CategoryType.various;
    }
    
 Deadline deadline = deadlineCategorize(selectedDate!);
String localizedDeadline = deadline.getLocalizedName(context);

    // final localizations = AppLocalizations.of(context)!;
    // String localizedCategory = _selectedCategory!.getLocalizedName(context);
    // String localizedDeadline;

    // switch (deadline) {
    //   case Deadline.outdate:
    //     localizedDeadline = localizations.outofdate;
    //     break;
    //   case Deadline.thisdate:
    //     localizedDeadline = localizations.thisdate;
    //     break;
    //   case Deadline.thismonth:
    //     localizedDeadline = localizations.thismonth;
    //     break;
    //   case Deadline.later:
    //     localizedDeadline = localizations.later;
    //     break;
    // }
  debugPrint("Selected Date: $selectedDate");
  debugPrint("Calculated Deadline: $deadline");

      Todos newTodo = Todos(
      id: uuid.v4(),
      deadline: deadline,
      date: selectedDate!,
      description: dsrcontroller.text.trim(),
      category: Category(type: _selectedCategory!),
    );
debugPrint("Description: ${dsrcontroller.text}");
debugPrint("Selected Date: $selectedDate");
debugPrint("Category: $_selectedCategory");

    todoprovider.addTodo(newTodo);


    // NotificationService.showNotification(
    //   id: 1,
    //   title: 'Έγκαιρη ειδοποίηση',
    //   body: dsrcontroller.text.trim(),
    // );

    DateTime notificationTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      12,
      00,
    );

    if (notificationTime.isBefore(DateTime.now())) {
      notificationTime = notificationTime.add(const Duration(days: 1));
    }

    NotificationService.scheduleNotification(
      id: newTodo.hashCode,
      title: 'Προειδοποίηση',
      body: dsrcontroller.text.trim(),
      scheduledNotificationDateTime: notificationTime,
    );

    debugPrint("Scheduling notification at: $notificationTime");
    final pending = await NotificationService.getPendingNotifications();
    for (var notification in pending) {
      debugPrint(
          "Pending Notification: ${notification.id} - ${notification.title}");
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Σημειωση καταχωρήθηκε')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoprovider = Provider.of<ListProvider>(context);
    List<Todos> todolist = todoprovider.getTodos.values.toList();
    DateTime now = DateTime.now();
    List<String> categories1 = ['hobbies', 'obligations', 'travels', 'various'];

    return SingleChildScrollView(
      child: Card(
        child: SizedBox(
          height: 256,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  controller: dsrcontroller,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: const UnderlineInputBorder(),
                    errorText: errortext,
                    errorStyle: const TextStyle(color: Colors.red),
                    counterText: '',
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Ensure we show an error text if limit exceeded
                      errortext = value.length > 20
                          ? 'Το όριο χαρακτήρων προσπεράστηκε'
                          : null;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        selectedDate == null
                            ? 'No date selected'
                            : DateFormat('d/M/y').format(selectedDate!),
                      ),
                      IconButton(
                        onPressed: _presentDayPicker,
                        icon: const Icon(
                          Icons.calendar_month,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                                  DropdownButton<CategoryType>(
                  value: _selectedCategory,
                  hint: Text(_selectedCategory == null 
                      ? 'Select a category' 
                      : _selectedCategory!.getLocalizedName(context)),
                  dropdownColor: kColorScheme.secondary,
                  items: CategoryType.values.map((category) {
                    return DropdownMenuItem<CategoryType>(
                      value: category,
                      child: Text(category.getLocalizedName(context)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          submitTodo();
                          todoprovider.loadTodos();
                          dsrcontroller.clear();
                        });
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}