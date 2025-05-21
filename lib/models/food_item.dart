import 'package:hive/hive.dart';
part 'food_item.g.dart';

@HiveType(typeId: 0)
class FoodItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String imageUrl;

  @HiveField(2)
  bool isFavorite;

  @HiveField(3)
  String category;

  FoodItem({
    required this.name,
    required this.imageUrl,
    this.isFavorite = false,
    required this.category,
  });
}
