import 'package:todo/models/todolist.dart';

class DeadlineHelper {
  static Deadline categorize(DateTime selectedDate) {
    final now = DateTime.now();
    final nowDate = DateTime(now.year, now.month, now.day);
    final selectedDateOnly = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
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
}
