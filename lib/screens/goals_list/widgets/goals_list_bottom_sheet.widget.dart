import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';

class AddGoalBottomSheetWidget extends StatefulWidget {
  @override
  _AddGoalBottomSheetState createState() => _AddGoalBottomSheetState();
}

class _AddGoalBottomSheetState extends State<AddGoalBottomSheetWidget> {
  PageController _pageViewController = PageController();
  TimeOfDay timeToRemind;
  String title;
  String replacingWith;

  @override
  Widget build(BuildContext context) {
    final _timeChooser = () async {
      final TimeOfDay _timeToRemind = await showTimePicker(
          context: context, initialTime: TimeOfDay(hour: 7, minute: 0));
      if (_timeToRemind != null) {
        setState(() {
          timeToRemind = _timeToRemind;
        });
      }
    };

    double keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    if ((keyboardPadding / (MediaQuery.of(context).size.height)) > 0.4) {
      keyboardPadding =
          keyboardPadding > 40 ? keyboardPadding - 40 : keyboardPadding;
    }

    return Container(
      padding: EdgeInsets.only(bottom: keyboardPadding),
      child: Container(
        // height: 96,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        child: PageView(
          controller: _pageViewController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            // Goal Title
            Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              Row(children: <Widget>[
                // Title TextField
                Expanded(
                    child: TextField(
                  // onEditingComplete: () => _timeChooser(),
                  onChanged: (value) => title = value,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Add a new goal', border: InputBorder.none),
                ))
              ]),

              // Submit  Button
              Row(children: <Widget>[
                Spacer(flex: 1),

                // Save Button
                FlatButton(
                  textColor: AppColors.PRIMARY,
                  child: Text('Next', style: TextStyle(fontSize: 16)),
                  onPressed: () => title != null
                      ? _pageViewController.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn)
                      : null,
                )
              ])
            ]),

            // Replace with
            Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              Row(children: <Widget>[
                // Title TextField
                Expanded(
                    child: TextField(
                  // onEditingComplete: () => _timeChooser(),
                  onChanged: (value) => replacingWith = value,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Replacing with (optional)',
                      border: InputBorder.none),
                ))
              ]),

              // Submit  Button
              Row(children: <Widget>[
                Spacer(flex: 1),

                // Save Button
                FlatButton(
                  textColor: AppColors.PRIMARY,
                  child: Text('Next', style: TextStyle(fontSize: 16)),
                  onPressed: () => _pageViewController.nextPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn),
                )
              ])
            ]),

            // Remind At
            Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              Row(children: <Widget>[
                // Title TextField
                Opacity(opacity: 0.72, child: Text('Remind At:')),

                timeToRemind == null
                    ? FlatButton.icon(
                        textColor: AppColors.PRIMARY,
                        icon: Icon(Icons.calendar_today, size: 14),
                        label: Text('Choose'),
                        onPressed: _timeChooser)
                    : FlatButton(
                        child: Text(timeToRemind.format(context)),
                        onPressed: _timeChooser),

                Spacer(flex: 1)
              ]),

              // Submit  Button
              Row(children: <Widget>[
                Spacer(flex: 1),

                // Save Button
                FlatButton(
                  textColor: AppColors.PRIMARY,
                  child: Text('Save', style: TextStyle(fontSize: 16)),
                  onPressed: timeToRemind != null ? _onSubmit : null,
                )
              ])
            ])
          ],
        ),
      ),
    );
  }

  _onSubmit() {
    Navigator.pop(
        context, Goal(title, timeToRemind, replacingWith: replacingWith));
  }
}
