import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_recipe_app/services/meal_service.dart';
import '../models/meal_model.dart';
import '../services/favorite_service.dart';
import '../widgets/meal_card.dart';

class MealsListPage extends StatefulWidget {
  const MealsListPage({super.key});

  @override
  _MealsListPageState createState() => _MealsListPageState();
}

class _MealsListPageState extends State<MealsListPage> {
  final MealService mealService = MealService();
  late Future<List<Meal>> mealsFuture;

  // Set<String> favoriteMeals = {};
  //
  // void toggleFavorite(String mealId) {
  //   setState(() {
  //     if (favoriteMeals.contains(mealId)) {
  //       favoriteMeals.remove(mealId);
  //     } else {
  //       favoriteMeals.add(mealId);
  //     }
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final category = ModalRoute.of(context)!.settings.arguments as String;
    mealsFuture = mealService.getMealsByCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(title: Text(
          "Meals: $category",
          style: TextStyle(
            fontSize: 24,
            //fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
          backgroundColor: Colors.purple[900]
      ),
      body: FutureBuilder<List<Meal>>(
        future: mealsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No meals found."));
          }

          final meals = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return MealCard(
                name: meal.name,
                thumbnail: meal.thumbnail,
                mealId: meal.id,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/meal-details',
                    arguments: meal.id,
                  );
                },
                isFavorite: Provider.of<FavoritesService>(context).isFavorite(meal.id),
                onFavoriteToggle: () {
                  Provider.of<FavoritesService>(context, listen: false).toggleFavorite(meal.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
