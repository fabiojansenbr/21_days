import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static const String SPLASH = '/';
  static const String ONBOARDING = '/onboarding';
  static const String LOGIN = '/login';
  static const String GOALS_LIST = '/goals_list';
  static const String GOALS_DETAILS = '/goals_details';
}

class AppColors {
  // static const Color PRIMARY = Color(0xFF16a085);
  static const Color PRIMARY = Colors.teal;
}

class StorageKeys {
  static const String name = 'name';
  static const String avatar = 'avatar';
  static const String goalsCompleted = 'goalsCompleted';
}

class CustomEvents {
  static const String goalDeleted = 'GOAL_DELETED';
  static const String goalUpdated = 'GOAL_UPDATED';
}
