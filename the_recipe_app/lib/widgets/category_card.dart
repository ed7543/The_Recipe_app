import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String thumbnail;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.thumbnail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                thumbnail,
                height: 80,
                width: 100,
                //fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.purple[900],
                ),
                //textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
