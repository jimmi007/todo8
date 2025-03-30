import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';


final uuid = Uuid();
final formatter = DateFormat('d/M/y');

enum CategoryType { hobbies, obligations, travels, various }

enum Deadline { outdate, thisdate, thismonth, later }

extension CategoryTypeExtension on CategoryType {
  String getLocalizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case CategoryType.hobbies:
        return localizations.hobbies;
      case CategoryType.obligations:
        return localizations.obligations;
      case CategoryType.travels:
        return localizations.travels;
      case CategoryType.various:
        return localizations.various;
    }
  }
}
extension DeadlineExtension on Deadline {
  String getLocalizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return toString().split('.').last; // Fallback

    switch (this) {
      case Deadline.outdate:
        return localizations.outofdate;
      case Deadline.thisdate:
        return localizations.thisdate;
      case Deadline.thismonth:
        return localizations.thismonth;
      case Deadline.later:
        return localizations.later;
    }
  }
}


class Category {
  final CategoryType type;
  
  Category({required this.type});

  Map<String, dynamic> toJson() => {'type': type.toString().split('.').last};

  factory Category.fromJson(Map<String, dynamic> json) {
    // Ensure `json['type']` exists and is valid
    if (json.containsKey('type') && json['type'] is String) {
      try {
        return Category(
          type: CategoryType.values.firstWhere(
            (e) => e.toString().split('.').last == json['type'],
            orElse: () => CategoryType.various, // Default category if invalid
          ),
        );
      } catch (e) {
        debugPrint("Error parsing CategoryType: $e");
      }
    }
    return Category(type: CategoryType.various); // Fallback if type is missing
  }
}

class Todos extends ChangeNotifier {
  final String id;
  final String description;
  final DateTime date;
  bool isCompleted;
  final Category category;
  final Deadline deadline;

  Todos({
    required this.id,
    required this.description,
    required this.date,
    required this.category,
    this.isCompleted = false,
    required this.deadline,
  });

  String get formattedDate => formatter.format(date);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'date': date.toIso8601String(),
      'category': category.toJson(),
      'isCompleted': isCompleted,
      'deadline': deadline.toString().split('.').last,
    };
  }

  factory Todos.fromJson(Map<String, dynamic> json) {
    try {
      return Todos(
        id: json['id'] ?? uuid.v4(), // Ensure ID is present
        description: json['description'] ?? 'No description', // Default text
        date: json.containsKey('date') ? DateTime.parse(json['date']) : DateTime.now(), // Default to today
        category: json.containsKey('category') ? Category.fromJson(json['category']) : Category(type: CategoryType.various),
        isCompleted: json['isCompleted'] ?? false,
        deadline: json.containsKey('deadline') && json['deadline'] is String
            ? Deadline.values.firstWhere(
                (e) => e.toString().split('.').last == json['deadline'],
                orElse: () => Deadline.later, // Default deadline if invalid
              )
            : Deadline.later,
      );
    } catch (e) {
      debugPrint("Error decoding Todos: $e");
      return Todos(
        id: uuid.v4(),
        description: 'Invalid Data',
        date: DateTime.now(),
        category: Category(type: CategoryType.various),
        isCompleted: false,
        deadline: Deadline.later,
      );
    }
  }
}
