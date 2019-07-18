import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/goals_list/widgets/profile.widget.dart';

class GoalsListScreen extends StatefulWidget {
  @override
  _GoalsListScreenState createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GoalsFab(),
        body: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            // App Bar
            SliverAppBar(
              // title: Text('21 days'),
              backgroundColor: AppColors.PRIMARY,
              floating: false,
              pinned: true,
              expandedHeight: 256,
              flexibleSpace: FlexibleSpaceBar(
                // title: Image.asset('assets/images/logo.png'),
                background: Container(
                  color: AppColors.PRIMARY,
                  child: ProfileWidget(),
                ),
              ),
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
            trailing: IconButton(icon: Icon(Icons.add), onPressed: () {})));
      }
    }
    _children.add(SizedBox(height: 64));
    return _children;
  }
}

class GoalsFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(Icons.add),
      label: Text('Add a new Goal'),
      onPressed: () {},
    );
  }
}
