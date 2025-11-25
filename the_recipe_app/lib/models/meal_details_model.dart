class MealDetail {
  String id;
  String name;
  String? alternateName;
  String category;
  String area;
  String instructions;
  String thumbnail;
  String? tags;
  String? youtube;
  List<Map<String, String>> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    this.alternateName,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    this.tags,
    this.youtube,
    required this.ingredients

  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ing != null && ing.toString().trim().isNotEmpty) {
        ingredients.add({
          'ingredient': ing.toString(),
          'measure': measure?.toString() ?? '',
        });
      }
    }

    return MealDetail(
      id: json['idMeal'],
      name: json['strMeal'],
      alternateName: json['strMealAlternate'],
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
      tags: json['strTags'],
      youtube: json['strYoutube'],
      ingredients: ingredients,
    );
  }

}