import 'package:flutter/material.dart';
import 'package:the_recipe_app/services/category_service.dart';
import 'package:the_recipe_app/services/meal_service.dart';
import '../models/category_model.dart';
import '../widgets/category_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryService categoryService = CategoryService();
  final MealService mealService = MealService();
  late Future<List<Category>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = categoryService.getCategories();
  }

  // Function to fetch a random meal and navigate
  void _goToRandomMeal() async {
    try {
      final randomMeal = await mealService.getRandomMeal();
      Navigator.pushNamed(
        context,
        '/meal-details',
        arguments: randomMeal.id,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading random meal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: const Text(
          "Meal Categories",
          style: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple[900],
        centerTitle: true,
      ),
      body: FutureBuilder<List<Category>>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No categories found."));
          }

          final categories = snapshot.data!;

          return Column(
            children: [
              // random meal kopce
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _goToRandomMeal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[900],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Random Meal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // cards za categories
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryCard(
                      name: category.name,
                      thumbnail: category.thumbnail,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/meals',
                          arguments: category.name,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
