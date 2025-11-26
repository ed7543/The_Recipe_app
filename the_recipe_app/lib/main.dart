import 'package:flutter/material.dart';
import 'package:the_recipe_app/screens/home_list_category_screen.dart';
import 'package:the_recipe_app/screens/meal_details_screen.dart';
import 'package:the_recipe_app/screens/meals_list_screen.dart';

void main() {
  runApp(const MyApp());
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
      // Define named routes
      routes: {
        '/': (context) => const HomePage(),
        '/meals': (context) => const MealsListPage(),
      },
      // Handle routes with arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/meal-details') {
          final mealId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => MealDetailsPage(mealId: mealId),
          );
        }
        return null; // fallback for undefined routes
      },
    );
  }
}
