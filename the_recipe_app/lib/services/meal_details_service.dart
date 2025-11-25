import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/meal_details_model.dart';


class MealDetailService {
  Future<MealDetail> getMealDetails(String id) async {
    final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load meal details");
    }

    final data = jsonDecode(response.body);
    return MealDetail.fromJson(data['meals'][0]);
  }
}
