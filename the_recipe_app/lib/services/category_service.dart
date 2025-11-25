import 'dart:convert';
import 'package:the_recipe_app/models/category_model.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  static const String baseUrl = 'www.themealdb.com/api/json/v1/1';

  // fetch categories
  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List categoriesJson = data['categories'];

      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed loading: Categories.');
    }
  }
}