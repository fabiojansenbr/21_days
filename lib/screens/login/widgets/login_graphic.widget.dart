import 'package:flutter/widgets.dart';

import '../../../constants.dart';

class LoginGraphicWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.PRIMARY,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32))),
      child: Container(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
            Expanded(child: Image.asset('assets/images/logo.png')),
            Expanded(child: Image.asset('assets/images/illus_login.png')),
          ])),
    );
  }
}
