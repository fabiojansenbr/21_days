import 'dart:async';

import 'package:broadcast_events/broadcast_events.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/goal_details/widgets/day_complete_dialog.widget.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.view_model.dart';
import 'package:twenty_one_days/screens/goals_list/widgets/goals_list_bottom_sheet.widget.dart';
import 'package:twenty_one_days/screens/goals_list/widgets/profile.widget.dart';
import 'package:twenty_one_days/utilities/push_helper.dart';
import 'package:twenty_one_days/utilities/storage_helper.dart';
import 'package:twenty_one_days/utilities/utilities.dart';

class GoalsListScreen extends StatefulWidget {
  @override
  _GoalsListScreenState createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  bool textHidden = true;
  ScrollController _controller = ScrollController();
  GoalsListViewModel model;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_computeAppTitleVisibilty);
    model = GoalsListViewModel();
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });

    BroadcastEvents()
        .subscribe<GoalEventArgument>(CustomEvents.goalDeleted, _onGoalDelete);
    BroadcastEvents()
        .subscribe<GoalEventArgument>(CustomEvents.goalUpdated, _onGoalUpdate);
  }

  _computeAppTitleVisibilty() {
    if (_controller.hasClients && _controller.offset > (200 - kToolbarHeight)) {
      if (textHidden) {
        setState(() {
          textHidden = false;
        });
      }
    } else {
      if (!textHidden) {
        setState(() {
          textHidden = true;
        });
      }
    }
  }

  _openSheet() async {
    Goal newGoal = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddGoalBottomSheetWidget();
      },
      backgroundColor: Colors.transparent,
      // isScrollControlled: true
    );

    if (newGoal != null) {
      model.addNewGoal(newGoal);
      print('The Goal is ${newGoal.title}');
    }
  }

  @override
  Widget build(BuildContext context) {
    PushHelper().context = context;
    if (!PushHelper().canNavigate.isCompleted) {
      PushHelper().canNavigate.complete();
    }

    return Container(
      // color: Colors.white,
      child: Scaffold(
        // bottomSheets: isSheetOpened ? AddGoalBottomSheet() : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('Add a new Goal'),
          onPressed: _openSheet,
        ),
        body: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            // App Bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: AnimatedOpacity(
                opacity: textHidden ? 0 : 1,
                duration: Duration(milliseconds: 200),
                child: Text(
                  '21 Days',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
              // backgroundColor: AppColors.PRIMARY,
              floating: false,
              pinned: true,
              expandedHeight: 216,
              flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                // REF: https://stackoverflow.com/questions/53372276/flutter-how-to-check-if-sliver-appbar-is-expanded-or-collapsed
                // if (constraints.biggest.height == 80) {
                //   textHidden = false;
                // } else {
                //   textHidden = true;
                // }

                return FlexibleSpaceBar(
                  // title: Image.asset('assets/images/logo.png'),
                  background: Container(
                    color: AppColors.PRIMARY,
                    child: ProfileWidget(),
                  ),
                );
              }),
            ),

            // Sliver Fixed Extent
            ScopedModel<GoalsListViewModel>(
              model: model,
              child: ScopedModelDescendant<GoalsListViewModel>(
                  builder: (context, widget, model) {
                return SliverList(delegate: SliverChildListDelegate(_list));
              }),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> get _list {
    List<Widget> _children = [];
    if (model.goals != null && model.goals.isNotEmpty) {
      // Add Children for Goals List
      model.goals.forEach((goal) {
        int daysLeft = Utils.getDaysLeft(goal);
        _children.add(InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.GOALS_DETAILS,
              arguments: GoalDetailArgument(goal: goal)),
          child: ListTile(
              leading: CircularProgressIndicator(
                value: Utils.getProgressValue(daysLeft),
                backgroundColor: Colors.black26,
              ),
              title: Text(goal.title ?? ''),
              subtitle:
                  Text('$daysLeft ${daysLeft == 1 ? "day" : "days"} left'),
              trailing: Utils.canMarkAsComplete(goal)
                  ? IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () => _markAsComplete(goal))
                  : SizedBox(width: 48)),
        ));
      });

      // Add Spacer for FAB
      _children.add(SizedBox(height: 64));
    } else {
      _children.add(Container(
          padding: EdgeInsets.all(32),
          child: Center(
              child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: StorageHelper.hadGoalsState
                    ? MediaQuery.of(context).size.width * 0.64
                    : MediaQuery.of(context).size.width * 0.48),
            child: Image.asset(StorageHelper.hadGoalsState
                ? 'assets/images/all_done.png'
                : 'assets/images/no_goals.png'),
          ))));
    }
    return _children;
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
      _deleteGoal(goal);
    }
    setState(() {});
  }

  _deleteGoal(Goal goal) {
    StorageHelper().deleteGoal(goal.id);
    PushHelper().cancelNotification(goal.id);
    model.goals.remove(goal);
  }

  _onGoalDelete(GoalEventArgument goalDeleted) {
    if (goalDeleted != null) {
      Goal goalToRemove =
          model.goals.firstWhere((goal) => goalDeleted.goal.id == goal.id);
      model.removeGoal(goalToRemove);
    }
  }

  _onGoalUpdate(GoalEventArgument goalUpdated) {
    if (goalUpdated != null) {
      model.updateGoal(goalUpdated.goal);
    }
  }

  @override
  void dispose() {
    BroadcastEvents()
        .unsubscribe(CustomEvents.goalDeleted, handler: _onGoalDelete);
    BroadcastEvents()
        .unsubscribe(CustomEvents.goalUpdated, handler: _onGoalUpdate);
    super.dispose();
  }
}
