import 'package:broadcast_events/broadcast_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/goal_details/widgets/day_complete_dialog.widget.dart';
import 'package:twenty_one_days/screens/goal_details/widgets/goal_progress.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';
import 'package:twenty_one_days/utilities/push_helper.dart';
import 'package:twenty_one_days/utilities/storage_helper.dart';
import 'package:twenty_one_days/utilities/utilities.dart';

class GoalsDetailsScreen extends StatefulWidget {
  @override
  _GoalsDetailsScreenState createState() => _GoalsDetailsScreenState();
}

class _GoalsDetailsScreenState extends State<GoalsDetailsScreen> {
  TimeOfDay timeToRemind;
  double height;
  GoalDetailArgument args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    timeToRemind = args.goal.remindAt;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text('Goal Details'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteGoal,
            )
          ],
        ),
        body: _scrollableContent);
  }

  _deleteGoal() {
    StorageHelper().deleteGoal(args.goal.id);
    PushHelper().cancelNotification(args.goal.id);
    BroadcastEvents().publish<GoalEventArgument>(CustomEvents.goalDeleted,
        arguments: GoalEventArgument(args.goal));
    Navigator.of(context).pop();
  }

  Widget get _scrollableContent {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      if (height == null) {
        height = viewportConstraints.maxHeight;
      }
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: height, minWidth: viewportConstraints.maxWidth),
          child: Container(
            // color: Colors.white,
            color: AppColors.PRIMARY,
            child: IntrinsicHeight(
              child: _getContent(context),
            ),
          ),
        ),
      );
    });
  }

  Widget _getContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        // Goal Details
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
          child: GoalProgressWidget(args.goal),
        ),

        // Call to action
        Utils.canMarkAsComplete(args.goal)
            ? ButtonTheme(
                height: 48,
                minWidth: 216,
                child: RaisedButton(
                  color: Colors.white,
                  // textColor: Colors.white,
                  child: Text('Mark as Complete'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64)),
                  onPressed: () => _markAsComplete(args.goal),
                ),
              )
            : Container(),

        // Oops Button
        Utils.canMarkAsComplete(args.goal)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  child: Text('Missed it! Start Again'),
                  // textColor: AppColors.PRIMARY,
                  textColor: Colors.white,
                  onPressed: () => _startAgain(args.goal),
                ),
              )
            : Container(),

        SizedBox(height: 32)
      ],
    );
  }

  _startAgain(Goal goal) async {
    bool startAgain =
        await Utils.showConfirm(context, 'Restart goal progress?');
    if (startAgain) {
      goal.start = DateTime.now().millisecondsSinceEpoch;
      await StorageHelper().updateGoal(goal);
      Utils.publishUpdate(goal);
      setState(() {});
    }
  }

  _markAsComplete(Goal goal) async {
    final bool are21DaysOver = Utils.getDaysLeft(goal) == 1;
    goal.lastMarkAsCompletedAt = DateTime.now().millisecondsSinceEpoch;
    await StorageHelper().updateGoal(goal);
    await showDialog(
        context: context,
        builder: (_) {
          return DayCompleteDialogWidget(are21DaysCompleted: are21DaysOver);
        });
    if (are21DaysOver) {
      _deleteGoal();
    } else {
      Utils.publishUpdate(goal);
      setState(() {});
    }
  }
}
