import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';
import 'package:twenty_one_days/screens/goals_list/widgets/goals_list_bottom_sheet.widget.dart';
import 'package:twenty_one_days/screens/goals_list/widgets/profile.widget.dart';

class GoalsListScreen extends StatefulWidget {
  @override
  _GoalsListScreenState createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  bool textHidden = true;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.hasClients &&
          _controller.offset > (200 - kToolbarHeight)) {
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
    });
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
      print('The Goal is ${newGoal.title}');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: AppColors.PRIMARY,
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
            SliverList(delegate: SliverChildListDelegate(_list))
          ],
        ),
      ),
    );
  }

  List<Widget> get _list {
    List<Widget> _children = [];
    for (int i = 0; i < 18; i++) {
      int progress = Random().nextInt(21);
      if (progress != 0) {
        _children.add(ListTile(
            leading: CircularProgressIndicator(
              value: ((21 - progress) / 21),
              backgroundColor: Colors.black26,
            ),
            title: Text('Awesome Goal'),
            subtitle: Text('$progress days left'),
            trailing: IconButton(icon: Icon(Icons.done), onPressed: () {})));
      }
    }
    _children.add(SizedBox(height: 64));
    return _children;
  }
}
