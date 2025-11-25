import 'package:flutter/material.dart';
import 'package:the_recipe_app/services/category_service.dart';

import '../models/category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState {
  final CategoryService categoryService = CategoryService();
  late Future<List<Category>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = categoryService.getCategories();
  }
}