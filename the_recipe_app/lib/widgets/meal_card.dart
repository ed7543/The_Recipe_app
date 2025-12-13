import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorite_service.dart';

class MealCard extends StatelessWidget {
  final String name;
  final String thumbnail;
  final String mealId;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const MealCard({
    super.key,
    required this.name,
    required this.thumbnail,
    required this.mealId,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 10),
        elevation: 4,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                thumbnail,
                height: 100,
                width: 110,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[900],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            // Heart button
            Consumer<FavoritesService>(
              builder: (context, favorites, _) {
                final isFavorite = favorites.isFavorite(mealId);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.deepPurpleAccent : Colors.purple[900],
                  ),
                  onPressed: onFavoriteToggle,
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
