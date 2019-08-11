import 'package:flutter/material.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';
import 'package:twenty_one_days/utilities/push_helper.dart';
import 'package:twenty_one_days/utilities/storage_helper.dart';
import 'package:twenty_one_days/utilities/utilities.dart';

import '../../../constants.dart';

class GoalProgressWidget extends StatefulWidget {
  final Goal goal;
  GoalProgressWidget(this.goal);

  @override
  _GoalProgressWidgetState createState() => _GoalProgressWidgetState();
}

class _GoalProgressWidgetState extends State<GoalProgressWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> curve;
  Tween<double> valueTween;

  @override
  void initState() {
    this._controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    this._controller.forward();

    this.curve =
        CurvedAnimation(parent: this._controller, curve: Curves.easeIn);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int daysLeft = Utils.getDaysLeft(widget.goal);
    double progressWidth = MediaQuery.of(context).size.width * 0.60;
    double percentage = Utils.getProgressValue(daysLeft);

    this.valueTween = Tween<double>(
      begin: 0,
      end: percentage,
    );

    TimeOfDay timeToRemind = widget.goal.remindAt;

    final _timeChooser = () async {
      final TimeOfDay _timeToRemind = await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay(hour: timeToRemind.hour, minute: timeToRemind.minute));
      if (_timeToRemind != null) {
        setState(() {
          widget.goal.remindAt = timeToRemind = _timeToRemind;
          StorageHelper().updateGoal(widget.goal);
          Utils.publishUpdate(widget.goal);
        });
        await PushHelper().cancelNotification(widget.goal.id);
        await PushHelper().scheduleNotification(widget.goal);
      }
    };

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // Goal Title
        Text(
          widget.goal.title ?? '',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              // color: Colors.black87),
              color: Colors.white),
          textAlign: TextAlign.left,
        ),

        // Replacing With
        widget.goal.replacingWith != null
            ? Container(
                margin: EdgeInsets.only(top: 8),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'instead,\n',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          color: Colors.white70)),
                  TextSpan(
                      text: widget.goal.replacingWith,
                      style: TextStyle(fontSize: 28, color: Colors.white)),
                ])))
            : Container(),

        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          // Remind at
          // Opacity(opacity: 0.72, child: Text('Reminding At:')),
          Icon(Icons.calendar_today, size: 18, color: Colors.white),

          // timeToRemind == null
          //     ? FlatButton.icon(
          //         textColor: AppColors.PRIMARY,
          //         icon: Icon(Icons.calendar_today, size: 14),
          //         label: Text('Choose'),
          //         onPressed: _timeChooser)
          //     :
          FlatButton(
              textColor: Colors.white,
              child: Text(
                timeToRemind.format(context),
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _timeChooser),
        ]),

        // Spacer
        SizedBox(height: 48),

        // Goal Progress
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: progressWidth,
                      width: progressWidth,
                      child: Stack(
                        children: <Widget>[
                          // Progress Bar
                          Container(
                            width: progressWidth,
                            height: progressWidth,
                            child: AnimatedBuilder(
                                animation: this.curve,
                                builder: (context, child) {
                                  return CircularProgressIndicator(
                                      strokeWidth: 20,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xeeffffff)),
                                      backgroundColor: Colors.black12,
                                      value:
                                          this.valueTween.evaluate(this.curve));
                                }),
                          ),

                          // Percentage
                          Container(
                            height: progressWidth,
                            width: progressWidth,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                AnimatedBuilder(
                                    animation: this._controller,
                                    builder: (context, child) {
                                      return Text(
                                        '${(this.valueTween.evaluate(this.curve) * 100).truncate()}%',
                                        style: TextStyle(
                                            fontSize: 40, color: Colors.white),
                                      );
                                    }),
                                // Text(
                                //   '${(percentage * 100).truncate()}%',
                                //   style: TextStyle(fontSize: 40),
                                // ),
                                Text('CONQUERED',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white))
                              ],
                            )),
                          )
                        ],
                      )),

                  //Spacer
                  SizedBox(height: 40),

                  // Days Remaining
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: '$daysLeft',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                            color: Colors.white)),
                    TextSpan(
                        text: ' ${daysLeft == 1 ? "day" : "days"} left',
                        style: TextStyle(fontSize: 24, color: Colors.white54)),
                  ]))
                ]),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
