import 'package:flutter/material.dart';
import 'package:the_recipe_app/services/category_service.dart';
import '../models/category_model.dart';
import '../widgets/category_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryService categoryService = CategoryService();
  late Future<List<Category>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = categoryService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Categories")),
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

          return ListView.builder(
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
          );
        },
      ),
    );
  }
}
