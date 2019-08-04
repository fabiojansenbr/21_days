import 'dart:async';

import 'package:broadcast_events/broadcast_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';

class Utils {
  static final Utils _singleton = new Utils._internal();

  factory Utils() {
    return _singleton;
  }

  Utils._internal();

  static int getDaysLeft(Goal goal) {
    // int nowDay = DateTime.now().day;
    // int startDay = DateTime.fromMillisecondsSinceEpoch(goal.start).day;
    // int daysPassed = nowDay - startDay;
    // return 21 - (daysPassed > 0 ? daysPassed : 0);
    DateTime now = DateTime.now();
    DateTime start = DateTime.fromMillisecondsSinceEpoch(goal.start);
    int difference = now.difference(start).inDays;
    int daysLeft = 21 - (difference > 0 ? difference : 0);
    // return daysLeft;
    DateTime marked =
        DateTime.fromMillisecondsSinceEpoch(goal.lastMarkAsCompletedAt ?? 0);
    return marked.day == now.day ? daysLeft - 1 : daysLeft;
  }

  static double getProgressValue(int daysLeft) {
    return ((21 - daysLeft) / 21) + 0.001;
  }

  static bool canMarkAsComplete(Goal goal) {
    DateTime now = DateTime.now();
    bool notMarkedToday;
    if (goal.lastMarkAsCompletedAt != null) {
      DateTime lastMarkedAsCompleteAt =
          DateTime.fromMillisecondsSinceEpoch(goal.lastMarkAsCompletedAt);
      notMarkedToday = now.difference(lastMarkedAsCompleteAt).inDays > 0;
    } else {
      notMarkedToday = true;
    }
    bool isCurrentTimeAfterRemindTime =
        goal.remindAtDateTime.millisecondsSinceEpoch <=
            now.millisecondsSinceEpoch;
    // return true;
    return notMarkedToday && isCurrentTimeAfterRemindTime;
  }

  static bool hasUnresolvedProgressInDays(Goal goal) {
    DateTime now = DateTime.now();
    DateTime startedAt = DateTime.fromMillisecondsSinceEpoch(goal.start);
    if (goal.lastMarkAsCompletedAt == null &&
        now.difference(startedAt).inDays > 1) {
      return true;
    } else {
      DateTime lastMarkedAt =
          DateTime.fromMillisecondsSinceEpoch(goal.lastMarkAsCompletedAt);
      if (now.difference(lastMarkedAt).inDays > 1) {
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<bool> showConfirm(BuildContext context, String title) async {
    Completer<bool> _completer = Completer<bool>();
    showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(title), actions: <Widget>[
            // Cancel
            FlatButton(
                child: Text('Cancel'),
                textColor: Colors.black45,
                onPressed: () {
                  _completer.complete(false);
                  Navigator.of(context).pop();
                }),

            // Confim
            FlatButton(
                child: Text('Confirm'),
                onPressed: () {
                  _completer.complete(true);
                  Navigator.of(context).pop();
                })
          ]);
        });
    return _completer.future;
  }

  static publishUpdate(Goal goal) {
    BroadcastEvents().publish<GoalEventArgument>(CustomEvents.goalUpdated,
        arguments: GoalEventArgument(goal));
  }
}
