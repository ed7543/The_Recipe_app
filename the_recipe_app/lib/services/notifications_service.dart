// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import '../services/meal_service.dart';
// import '../models/meal_model.dart';
//
// class NotificationsService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//   FlutterLocalNotificationsPlugin();
//
//   /// Initialize local notifications
//   static Future<void> init() async {
//     tz.initializeTimeZones();
//
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings();
//
//     const settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await _notifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (details) {
//         print('Notification tapped: ${details.payload}');
//         // Navigate to meal details if needed
//       },
//     );
//   }
//
//   /// Show a notification immediately for testing
//   static Future<void> showTestNotification() async {
//     const androidDetails = AndroidNotificationDetails(
//       'test_channel',
//       'Test Notifications',
//       channelDescription: 'Testing notifications immediately',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const iosDetails = DarwinNotificationDetails();
//
//     const platformDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _notifications.show(
//       0,
//       'Test Recipe',
//       'This is a test notification',
//       platformDetails,
//       payload: 'test_payload',
//     );
//   }
//
//   /// Schedule a daily notification at a given time
//   static Future<void> scheduleDailyRandomRecipe({
//     int hour = 21,
//     int minute = 0,
//   }) async {
//     final meals = await MealService().getAllMeals(count: 20);
//     if (meals.isEmpty) return;
//
//     final randomMeal = meals[Random().nextInt(meals.length)];
//
//     final androidDetails = AndroidNotificationDetails(
//       'daily_recipe_channel',
//       'Daily Recipe',
//       channelDescription: 'Daily random recipe notification',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     final iosDetails = DarwinNotificationDetails();
//
//     final platformDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     final now = tz.TZDateTime.now(tz.local);
//     var scheduledTime =
//     tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
//
//     // Schedule for tomorrow if time already passed
//     if (scheduledTime.isBefore(now)) {
//       scheduledTime = scheduledTime.add(const Duration(days: 1));
//     }
//
//     await _notifications.zonedSchedule(
//       0,
//       'Recipe of the Day',
//       randomMeal.name,
//       scheduledTime,
//       platformDetails,
//       payload: randomMeal.id,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
// }
