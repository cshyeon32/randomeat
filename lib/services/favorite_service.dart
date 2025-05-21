import 'package:hive/hive.dart';
import 'package:random_eat/models/food_item.dart';

class FoodService {
  final Box<FoodItem> _foodBox = Hive.box<FoodItem>('foods');

  List<FoodItem> getAllFoods() {
    return _foodBox.values.toList();
  }

  FoodItem getRandomFood() {
    final foods = getAllFoods();
    foods.shuffle();
    return foods.first;
  }

  void toggleFavorite(FoodItem item) {
    item.isFavorite = !item.isFavorite;
    item.save();
  }

  List<FoodItem> getFavorites() {
    return getAllFoods().where((f) => f.isFavorite).toList();
  }

  Future<void> addFood(FoodItem food) async {
    await _foodBox.add(food);
  }

  Future<void> deleteFood(FoodItem food) async {
    await food.delete();
  }
}
