import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/goal_details/goal_details.screen.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.screen.dart';
import 'package:twenty_one_days/screens/login/login.screen.dart';
import 'package:twenty_one_days/screens/onboarding/onboarding.screen.dart';
import 'package:twenty_one_days/screens/splash/splash.screen.dart';

class TwentyOneDays extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set Status Bar Theme
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark, statusBarColor: Colors.teal));

    // Our Material App
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '21 Days',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: AppRoutes.SPLASH,
        routes: {
          AppRoutes.SPLASH: (context) => SplashScreen(),
          AppRoutes.LOGIN: (context) => LoginScreen(),
          AppRoutes.ONBOARDING: (context) => OnboardingScreen(),
          AppRoutes.GOALS_LIST: (context) => GoalsListScreen(),
          AppRoutes.GOALS_DETAILS: (context) => GoalsDetailsScreen(),
        });
  }
}
