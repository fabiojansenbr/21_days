import 'package:flutter/material.dart';

class Goal {
  int id;
  String title;
  TimeOfDay remindAt;
  int start;

  Goal(
    this.title,
    this.remindAt,
  ) {
    start = DateTime.now().millisecondsSinceEpoch;
    // start = (DateTime.now().subtract(Duration(days: 4))).millisecondsSinceEpoch;
  }

  Goal.fromDbJson(Map<String, dynamic> dbJson) {
    id = dbJson['id'];
    title = dbJson['title'];
    start = dbJson['start'];
    remindAt = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(dbJson['timeToRemind']));
  }

  Map<String, dynamic> get toDbJson {
    final now = new DateTime.now();
    final temp =
        DateTime(now.year, now.month, now.day, remindAt.hour, remindAt.minute);
    int calculatdRemindAt = temp.millisecondsSinceEpoch;

    return {'title': title, 'remindAt': calculatdRemindAt, 'start': start};
  }

  DateTime get remindAtDateTime {
    final now = DateTime.now();
    final started = DateTime.fromMillisecondsSinceEpoch(start);
    if (started.hour > now.hour && started.day == now.day) {
      return DateTime(started.year, started.month, started.day, remindAt.hour,
          remindAt.minute);
    } else {
      return DateTime(started.year, started.month, started.day + 1,
          remindAt.hour, remindAt.minute);
    }
  }
}

class GoalDetailArgument {
  final Goal goal;

  GoalDetailArgument({this.goal});
}

class GoalDetailResponse {
  final Goal goal;
  final bool isGoalDeleted;

  GoalDetailResponse(this.goal, this.isGoalDeleted);
}
