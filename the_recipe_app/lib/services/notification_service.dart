import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../screens/meal_details_screen.dart';

class NotificationsService {
  static final NotificationsService _instance = NotificationsService._internal();
  factory NotificationsService() => _instance;
  NotificationsService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call this in main() or in initState
  Future<void> init(BuildContext context) async {
    // Request permissions (iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Notification permission status: ${settings.authorizationStatus}');

    // Get device token
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.notification!.title ?? 'You have a new notification'),
          ),
        );
      }
    });

    // Handle app opened from background notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.containsKey('mealId')) {
        final mealId = message.data['mealId'];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MealDetailsPage(mealId: mealId)),
        );
      }
    });
  }

  /// Subscribe user to daily recipe topic
  Future<void> subscribeToDailyRecipe() async {
    await _messaging.subscribeToTopic('daily_recipe');
  }

  Future<void> unsubscribeFromDailyRecipe() async {
    await _messaging.unsubscribeFromTopic('daily_recipe');
  }
}
