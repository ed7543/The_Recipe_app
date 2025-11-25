import 'package:flutter/material.dart';

class IngredientItem extends StatelessWidget {
  final String ingredient;
  final String measure;

  const IngredientItem({
    super.key,
    required this.ingredient,
    required this.measure,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$ingredient - $measure",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
