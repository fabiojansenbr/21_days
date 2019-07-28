import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';

typedef AvatarCallback = void Function(bool);

class LoginAvatarWidget extends StatefulWidget {
  final AvatarCallback onSubmit;

  LoginAvatarWidget(this.onSubmit);

  @override
  _LoginAvatarWidgetState createState() => _LoginAvatarWidgetState();
}

class _LoginAvatarWidgetState extends State<LoginAvatarWidget> {
  bool isMaleSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Choose avatar',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Colors.black87)),

            // Avatar
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Male
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMaleSelected = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: isMaleSelected
                              ? Border.all(color: AppColors.PRIMARY, width: 4)
                              : Border.all(color: Colors.white, width: 4),
                          borderRadius: BorderRadius.circular(88)),
                      child: Image.asset(
                        'assets/images/male.png',
                        width: 88,
                      ),
                    ),
                  ),

                  // Female
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMaleSelected = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: isMaleSelected
                              ? Border.all(color: Colors.white, width: 4)
                              : Border.all(color: AppColors.PRIMARY, width: 4),
                          borderRadius: BorderRadius.circular(88)),
                      child: Image.asset(
                        'assets/images/female.png',
                        width: 88,
                      ),
                    ),
                  ),
                ]),

            SizedBox(height: 8),

            // Continue
            ButtonTheme(
              height: 48,
              minWidth: 200,
              child: FlatButton(
                color: AppColors.PRIMARY,
                textColor: Colors.white,
                child: Text('Continue'),
                onPressed: () {
                  widget.onSubmit(isMaleSelected);
                },
              ),
            )
          ]),
    );
  }
}
