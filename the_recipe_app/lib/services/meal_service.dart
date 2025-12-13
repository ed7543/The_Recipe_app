import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:the_recipe_app/models/meal_details_model.dart';

import '../models/meal_model.dart';

class MealService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // fetch meals by category
  Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category' ));
    if(response.statusCode==200) {
      final data = json.decode(response.body);
      final List mealsJson = data['meals'];

      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed loading: Meals by category.');
    }
  }

  // fetch meals by meal id
  Future<MealDetail> getMealsById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    if(response.statusCode==200) {
      final data = json.decode(response.body);
      //final List mealsJson = data['meals'];

      //return mealsJson.map((json) => Meal.fromJson(json)).toList();
      return MealDetail.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed loading: Meals by ID.');
    }
  }

  // fetch meals by random api
  Future<MealDetail> getRandomMeal() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));
    if(response.statusCode==200) {
      final data = json.decode(response.body);
      
      return MealDetail.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed loading: Random meal.');
    }
  }

  // fetch multiple meals by list of IDs
  Future<List<MealDetail>> getMealsByIds(List<String> ids) async {
    List<MealDetail> meals = [];
    for (var id in ids) {
      try {
        final meal = await getMealsById(id);
        meals.add(meal);
      } catch (e) {
        // optional: skip failed meals
        print("Failed to load meal $id: $e");
      }
    }
    return meals;
  }

  // Fetch multiple random meals (say 20)
  Future<List<MealDetail>> getAllMeals({int count = 20}) async {
    List<MealDetail> meals = [];
    for (int i = 0; i < count; i++) {
      try {
        final meal = await getRandomMeal();
        meals.add(meal);
      } catch (e) {
        print("Failed to load random meal: $e");
      }
    }
    return meals;
  }
}

//}