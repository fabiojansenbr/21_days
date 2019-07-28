import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';

typedef FormCallback = void Function(String);

class LoginFormWidget extends StatefulWidget {
  final TextEditingController textController;

  final FormCallback onSubmit;

  LoginFormWidget(this.onSubmit, this.textController);

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Welcome ',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: Colors.black87)),
              TextSpan(
                  text: 'What should we call you?',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 22,
                      color: Colors.black87)),
            ])),

            // Enter Username
            Form(
              key: _formKey,
              child: TextFormField(
                controller: widget.textController,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'We would like to know your name';
                  }
                  return null;
                },
                // onFieldSubmitted: (_) => _onSubmit,
                // onEditingComplete: () => _onSubmit,
                decoration: InputDecoration(
                  hasFloatingPlaceholder: false,
                  labelText: 'You can call me',
                  // helperText: 'Your Nickname'
                  // focusedBorder: OutlineInputBorder(),
                  // enabledBorder: OutlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.grey))
                ),
              ),
            ),

            SizedBox(height: 16),

            // Continue
            ButtonTheme(
              height: 48,
              minWidth: 200,
              child: FlatButton(
                color: AppColors.PRIMARY,
                textColor: Colors.white,
                child: Text('Continue'),
                onPressed: () => _onSubmit(),
              ),
            )
          ]),
    );
  }

  _onSubmit() {
    if (_formKey.currentState.validate()) {
      widget.onSubmit(widget.textController.text);
    }
  }
}

// class _LoginFormWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(40),
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             // Signin with Google
//             ButtonTheme(
//               height: 48,
//               minWidth: 200,
//               child: RaisedButton.icon(
//                 icon: Container(
//                     width: 28,
//                     height: 28,
//                     child: Image.asset('assets/images/g_login_logo.png')),
//                 label: Text('Continue with Google'),
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4)),
//                 onPressed: () {},
//               ),
//             ),

//             // Divider
//             Container(
//                 width: 200,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: <Widget>[
//                     Divider(),
//                     Center(
//                       child: Container(
//                         color: Colors.white,
//                         padding: EdgeInsets.all(4),
//                         child: Text(
//                           'or',
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 )),

//             ButtonTheme(
//               height: 48,
//               minWidth: 200,
//               child: FlatButton(
//                 child: Text('Create User'),
//                 color: AppColors.PRIMARY,
//                 textColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4)),
//                 onPressed: () {
//                   Navigator.of(context).pushNamed(AppRoutes.GOALS_LIST);
//                 },
//               ),
//             ),
//             // Enter Username
//             // Column(
//             //     crossAxisAlignment: CrossAxisAlignment.end,
//             //     children: <Widget>[
//             //       TextFormField(
//             //         decoration: InputDecoration(
//             //             labelText: 'Enter Username',
//             //             focusedBorder: OutlineInputBorder(),
//             //             enabledBorder: OutlineInputBorder(
//             //                 borderSide: BorderSide(color: Colors.grey))),
//             //       ),
//             //       RaisedButton(
//             //         child: Text('Continue'),
//             //         onPressed: () {
//             //           Navigator.pushReplacementNamed(
//             //               context, AppRoutes.GOALS_LIST);
//             //         },
//             //       )
//             //     ])
//           ]),
//     );
//   }
// }
