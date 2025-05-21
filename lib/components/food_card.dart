import 'package:flutter/material.dart';
import 'package:random_eat/models/food_item.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onFavoriteToggle;

  const FoodCard(
      {super.key, required this.food, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Image.network(food.imageUrl, height: 200, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(food.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red),
            onPressed: onFavoriteToggle,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('random',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
