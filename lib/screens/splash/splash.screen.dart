import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _navigate(context);

    return Container(
        color: AppColors.PRIMARY,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Center(
                    child: Container(
                        width: 128,
                        height: 128,
                        child: Image.asset('assets/images/logo.png'))))
          ],
        ));
  }

  _navigate(BuildContext ctx) async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacementNamed(ctx, AppRoutes.ONBOARDING);
  }
}
