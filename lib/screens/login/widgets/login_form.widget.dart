import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';

class LoginFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Signin with Google
            ButtonTheme(
              height: 48,
              minWidth: 200,
              child: RaisedButton.icon(
                icon: Image.asset('assets/images/g_login_logo.png'),
                label: Text('Continue with Google'),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () {},
              ),
            ),

            // Divider
            Container(
                width: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Divider(),
                    Center(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(4),
                        child: Text(
                          'or',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                )),

            ButtonTheme(
              height: 48,
              minWidth: 200,
              child: FlatButton(
                child: Text('Create User'),
                color: AppColors.PRIMARY,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.GOALS_LIST);
                },
              ),
            ),
            // Enter Username
            // Column(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: <Widget>[
            //       TextFormField(
            //         decoration: InputDecoration(
            //             labelText: 'Enter Username',
            //             focusedBorder: OutlineInputBorder(),
            //             enabledBorder: OutlineInputBorder(
            //                 borderSide: BorderSide(color: Colors.grey))),
            //       ),
            //       RaisedButton(
            //         child: Text('Continue'),
            //         onPressed: () {
            //           Navigator.pushReplacementNamed(
            //               context, AppRoutes.GOALS_LIST);
            //         },
            //       )
            //     ])
          ]),
    );
  }
}
