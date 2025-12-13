import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_recipe_app/screens/favorites_screen.dart';
import 'package:the_recipe_app/screens/home_list_category_screen.dart';
import 'package:the_recipe_app/screens/meal_details_screen.dart';
import 'package:the_recipe_app/screens/meals_list_screen.dart';
import 'package:the_recipe_app/services/favorite_service.dart';


import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  String? token = await messaging.getToken();
  print('FCM Token: $token');

  // await NotificationsService.init();
  // await NotificationsService.scheduleDailyRandomRecipe();

  runApp(
    MultiProvider(
      providers: [
        // Lazy creation ensures Firebase is initialized before FavoritesService
        ChangeNotifierProvider(
          create: (_) => FavoritesService(userId: 'exampleUserId'),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/meals': (context) => const MealsListPage(),
        '/favorites': (context) => const FavoritesPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/meal-details') {
          final mealId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => MealDetailsPage(mealId: mealId),
          );
        }
        return null;
      },
    );
  }
}
