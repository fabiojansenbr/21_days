import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/utilities/storage_helper.dart';

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
    final String name = await StorageHelper().getName();
    await Future.delayed(Duration(seconds: 2));
    if (name != null && name.isNotEmpty) {
      Navigator.pushReplacementNamed(ctx, AppRoutes.GOALS_LIST);
    } else {
      Navigator.pushReplacementNamed(ctx, AppRoutes.ONBOARDING);
    }
    // Navigator.pushReplacementNamed(ctx, AppRoutes.ONBOARDING);
  }
}
