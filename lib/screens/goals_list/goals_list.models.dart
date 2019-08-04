import 'package:flutter/material.dart';

class Goal {
  int id;
  String title;
  TimeOfDay remindAt;
  int start;
  int lastMarkAsCompletedAt;
  String replacingWith;

  Goal(this.title, this.remindAt, {this.replacingWith}) {
    start = DateTime.now().millisecondsSinceEpoch;
    // start =
    //     (DateTime.now().subtract(Duration(days: 20))).millisecondsSinceEpoch;
  }

  Goal.fromDbJson(Map<String, dynamic> dbJson) {
    id = dbJson['id'];
    title = dbJson['title'];
    start = dbJson['start'];
    replacingWith = dbJson['replaceWith'];
    lastMarkAsCompletedAt = dbJson['lastMarkAsCompletedAt'];
    remindAt = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(dbJson['timeToRemind']));
  }

  Map<String, dynamic> get toDbJson {
    final now = new DateTime.now();
    final temp =
        DateTime(now.year, now.month, now.day, remindAt.hour, remindAt.minute);
    int calculatdRemindAt = temp.millisecondsSinceEpoch;

    return {
      'title': title,
      'remindAt': calculatdRemindAt,
      'start': start,
      'lastMarkAsCompletedAt': lastMarkAsCompletedAt,
      'replaceWith': replacingWith
    };
  }

  DateTime get remindAtDateTime {
    final now = DateTime.now();
    final started = DateTime.fromMillisecondsSinceEpoch(start);
    if (remindAt.hour >= now.hour && now.difference(started).inDays >= 0) {
      return DateTime(
          now.year, now.month, now.day, remindAt.hour, remindAt.minute);
    } else {
      return DateTime(
          now.year, now.month, now.day + 1, remindAt.hour, remindAt.minute);
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

class GoalEventArgument {
  final Goal goal;
  GoalEventArgument(this.goal);
}
