import 'package:flutter/widgets.dart';

import '../../../constants.dart';

class LoginGraphicWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
          color: AppColors.PRIMARY,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32))),
      child: Container(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Spacer(flex: 10),
        Expanded(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 128),
              child: Image.asset('assets/images/title.png')),
          flex: 30,
        ),
        Spacer(flex: 10),
        Expanded(
          child: Image.asset('assets/images/illus_login.png'),
          flex: 50,
        ),
      ])),
    );
  }
}
