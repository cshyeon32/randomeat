import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:random_eat/models/food_item.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Box<FoodItem> _foodBox;

  @override
  void initState() {
    super.initState();
    _foodBox = Hive.box<FoodItem>('foods');
  }

  void _toggleFavorite(FoodItem item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
      item.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _foodBox.values.where((food) => food.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기 음식'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('아직 좋아요한 음식이 없어요 😢'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final food = favorites[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(food.imageUrl,
                        width: 60, height: 60, fit: BoxFit.cover),
                    title: Text(food.name),
                    trailing: IconButton(
                      icon: Icon(
                        food.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: food.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => _toggleFavorite(food),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
