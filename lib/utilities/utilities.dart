import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';

class Utils {
  static final Utils _singleton = new Utils._internal();

  factory Utils() {
    return _singleton;
  }

  Utils._internal();

  static int getDaysLeft(Goal goal) {
    int nowDay = DateTime.now().day;
    int startDay = goal.remindAtDateTime.day;
    int daysPassed = nowDay - startDay;
    return 21 - (daysPassed > 0 ? daysPassed : 0);
  }

  static double getProgressValue(int daysLeft) {
    return ((21 - daysLeft) / 21) + 0.001;
  }
}
