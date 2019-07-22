import 'package:flutter/material.dart';

class Goal {
  String title;
  TimeOfDay remindAt;

  Goal(
    this.title,
    this.remindAt,
  );

  Goal.fromDbJson(Map<String, dynamic> dbJson) {
    title = dbJson['title'];
    remindAt = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(int.parse(dbJson['remindAt'])));
  }

  Map<String, dynamic> get toDbJson {
    final now = new DateTime.now();
    final temp =
        DateTime(now.year, now.month, now.day, remindAt.hour, remindAt.minute);
    String tempStr = temp.millisecondsSinceEpoch.toString();

    return {
      'title': title,
      'remindAt': tempStr,
    };
  }
}
