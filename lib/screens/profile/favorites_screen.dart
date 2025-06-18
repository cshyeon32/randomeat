import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_eat/models/food_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  Future<Box<FoodItem>> _openBox() async {
    if (!Hive.isBoxOpen('foodBox')) {
      return await Hive.openBox<FoodItem>('foodBox');
    }
    return Hive.box<FoodItem>('foodBox');
  }

  Widget buildImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        height: 60,
        width: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image_not_supported),
      );
    } else {
      return Image.file(
        File(imagePath),
        height: 60,
        width: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image_not_supported),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
      ),
      body: FutureBuilder<Box<FoodItem>>(
        future: _openBox(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hive 오류: ${snapshot.error}'));
          }

          final box = snapshot.data!;
          final favoriteItems = box.values
              .where((item) => item != null && item.isFavorite)
              .toList();

          if (favoriteItems.isEmpty) {
            return const Center(child: Text('즐겨찾기한 음식이 없습니다.'));
          }

          return ListView.builder(
            itemCount: favoriteItems.length,
            itemBuilder: (context, index) {
              final item = favoriteItems[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: buildImage(item.imageUrl),
                  ),
                  title: Text(item.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
