import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal_details_model.dart';
import '../services/meal_details_service.dart';
import '../widgets/meal_detail.dart';
import '../services/favorite_service.dart';

class MealDetailsPage extends StatefulWidget {
  final String mealId;

  const MealDetailsPage({super.key, required this.mealId});

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  late Future<MealDetail> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = MealDetailService().getMealDetails(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Meal Details",
          style: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple[900],
        actions: [
          Consumer<FavoritesService>(
            builder: (context, favorites, _) {
              final isFavorite = favorites.isFavorite(widget.mealId);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.purple[100] : Colors.white,
                ),
                onPressed: () {
                  favorites.toggleFavorite(widget.mealId);
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<MealDetail>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final meal = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.name,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("${meal.category} • ${meal.area}",
                    style: TextStyle(
                        fontSize: 18, color: Colors.grey.shade700)),
                const SizedBox(height: 6),
                if (meal.alternateName != null &&
                    meal.alternateName!.trim().isNotEmpty)
                  Text(meal.alternateName!,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic)),
                const SizedBox(height: 20),
                if (meal.tags != null)
                  Text("Tags: ${meal.tags}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                const Text("Ingredients",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...meal.ingredients.map((item) =>
                    IngredientItem(ingredient: item['ingredient']!, measure: item['measure']!)),
                const SizedBox(height: 25),
                const Text("Instructions",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(meal.instructions,
                    style: const TextStyle(fontSize: 16, height: 1.4)),
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(meal.thumbnail,
                      width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: 30),
                if (meal.youtube != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("YouTube Tutorial",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {},
                        child: Text(meal.youtube!,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
