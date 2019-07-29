import 'package:flutter/material.dart';
import 'package:twenty_one_days/screens/goal_details/widgets/goal_progress.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';
import 'package:twenty_one_days/utilities/push_helper.dart';
import 'package:twenty_one_days/utilities/storage_helper.dart';

class GoalsDetailsScreen extends StatefulWidget {
  @override
  _GoalsDetailsScreenState createState() => _GoalsDetailsScreenState();
}

class _GoalsDetailsScreenState extends State<GoalsDetailsScreen> {
  TimeOfDay timeToRemind;
  final TextEditingController _textEditingController = TextEditingController();
  double height;
  GoalDetailArgument args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;

    timeToRemind = args.goal.remindAt;
    final _timeChooser = () async {
      final TimeOfDay _timeToRemind = await showTimePicker(
          context: context, initialTime: TimeOfDay(hour: 7, minute: 0));
      if (_timeToRemind != null) {
        setState(() {
          timeToRemind = _timeToRemind;
        });
      }
    };

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Goal Details'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                StorageHelper().deleteGoal(args.goal.id);
                PushHelper().cancelNotification(args.goal.id);
                Navigator.of(context).pop(GoalDetailResponse(args.goal, true));
              },
            )
          ],
        ),
        body: _scrollableContent);
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
              minHeight: height,
              maxHeight: height,
              minWidth: viewportConstraints.maxWidth),
          child: Container(
            color: Colors.white,
            child: IntrinsicHeight(
              child: _getContent(context),
            ),
          ),
        ),
      );
    });
  }

  Widget _getContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
      width: MediaQuery.of(context).size.width,
      child: GoalProgressWidget(args.goal),
    );
  }
}
