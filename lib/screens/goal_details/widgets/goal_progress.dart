import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';
import 'package:twenty_one_days/utilities/utilities.dart';

class GoalProgressWidget extends StatelessWidget {
  final Goal goal;

  GoalProgressWidget(this.goal);

  @override
  Widget build(BuildContext context) {
    int daysLeft = Utils.getDaysLeft(goal);
    double progressWidth = MediaQuery.of(context).size.width * 0.64;
    double percentage = Utils.getProgressValue(daysLeft);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // Goal Title
        Text(
          goal.title ?? '',
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
    );
  }
}
