import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:twenty_one_days/screens/goal_details/goal_details.screen.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';
import 'package:twenty_one_days/utilities/storage_helper.dart';

class PushHelper {
  static final PushHelper _singleton = new PushHelper._internal();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;

  factory PushHelper() {
    return _singleton;
  }

  PushHelper._internal();

  init(BuildContext context) async {
    this.context = context;
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    final Goal goal = await StorageHelper().fetchGoalById(int.parse(payload));
    await Future.delayed(Duration(seconds: 4));
    await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => GoalsDetailsScreen(),
          settings: RouteSettings(arguments: GoalDetailArgument(goal: goal))),
    );
  }

  scheduleNotification(Goal goal) async {
    var time = new Time(goal.remindAt.hour, goal.remindAt.minute, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '63e8399167124bfeaf6f5cb8c067e39e',
        '21 Days - Notification Channel',
        'Shedule notification to display daily');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(goal.id, goal.title,
        'Tap to mark as complete', time, platformChannelSpecifics,
        payload: goal.id.toString());
  }

  cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  _showPush() async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ongoing: true,
        ticker: 'ticker');
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
}
