import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/goal_details/goal_details.screen.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.view_model.dart';
import 'package:twenty_one_days/screens/goals_list/widgets/goals_list_bottom_sheet.widget.dart';
import 'package:twenty_one_days/screens/goals_list/widgets/profile.widget.dart';
import 'package:twenty_one_days/utilities/push_helper.dart';
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
          onTap: () async {
            GoalDetailResponse res = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GoalsDetailsScreen(),
                    settings: RouteSettings(
                        arguments: GoalDetailArgument(goal: goal))));

            if (res != null && res.isGoalDeleted) {
              model.removeGoal(res.goal);
            }
          },
          child: ListTile(
              leading: CircularProgressIndicator(
                value: Utils.getProgressValue(daysLeft),
                backgroundColor: Colors.black26,
              ),
              title: Text(goal.title ?? ''),
              subtitle: Text('$daysLeft days left'),
              trailing: IconButton(icon: Icon(Icons.done), onPressed: () {})),
        ));
      });

      // Add Spacer for FAB
      _children.add(SizedBox(height: 64));
    } else {
      _children.add(Container(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No Goals. Please add one'))));
    }
    return _children;
  }
}
