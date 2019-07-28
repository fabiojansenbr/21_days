import 'package:flutter/material.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';
import 'package:twenty_one_days/utilities/storage_helper.dart';
import 'package:twenty_one_days/utilities/utilities.dart';

class GoalsDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoalDetailArgument args = ModalRoute.of(context).settings.arguments;
    int daysLeft = Utils.getDaysLeft(args.goal);
    double progressWidth = MediaQuery.of(context).size.width * 0.64;
    double percentage = Utils.getProgressValue(daysLeft);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Goal Details'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                StorageHelper().deleteGoal(args.goal.id);
                Navigator.of(context).pop(GoalDetailResponse(args.goal, true));
              },
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Goal Title
              Text(
                args.goal.title ?? '',
                style: TextStyle(
                    fontSize: 24,
                    // fontWeight: FontWeight.w500,
                    color: Colors.black87),
                textAlign: TextAlign.center,
              ),

              // Spacer
              SizedBox(height: 64),

              // Goal Progress
              Container(
                  height: progressWidth,
                  width: progressWidth,
                  child: Stack(
                    children: <Widget>[
                      // Progress Bar
                      Container(
                        width: progressWidth,
                        height: progressWidth,
                        child: CircularProgressIndicator(
                            strokeWidth: 16,
                            backgroundColor: Colors.black12,
                            value: percentage),
                      ),

                      // Percentage
                      Container(
                        height: progressWidth,
                        width: progressWidth,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${(percentage * 100).truncate()}%',
                              style: TextStyle(fontSize: 40),
                            ),
                            Text('CONQUERED', style: TextStyle(fontSize: 12))
                          ],
                        )),
                      )
                    ],
                  )),

              //Spacer
              SizedBox(height: 64),

              // Days Remaining
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: '$daysLeft',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        color: Colors.black)),
                TextSpan(
                    text: ' days left',
                    style: TextStyle(fontSize: 24, color: Colors.black54)),
              ])),
            ],
          ),
        ));
  }
}
