import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorite_service.dart';
import '../services/meal_service.dart';
import '../widgets/meal_card.dart';
import '../models/meal_details_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);
    final favoriteIds = favoritesService.favoriteMeals.toList();
    final mealService = MealService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple[900],
      ),
      body: FutureBuilder<List<MealDetail>>(
        future: mealService.getMealsByIds(favoriteIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No favorite meals yet."));
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
                isFavorite: favoritesService.isFavorite(meal.id),
                onFavoriteToggle: () =>
                    favoritesService.toggleFavorite(meal.id),
              );
            },
          );
        },
      ),
    );
  }
}
