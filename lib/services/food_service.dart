import 'package:hive/hive.dart';
import 'package:random_eat/models/food_item.dart';

class FoodService {
  final Box<FoodItem> _foodBox;

  FoodService(this._foodBox);

  List<String> getCategories() {
    final foods = _foodBox.values.toList();
    final categories =
        foods.map((e) => e.category).where((c) => c != '전체').toSet().toList();
    categories.sort();
    return ['전체', ...categories];
  }

  List<FoodItem> getFoodsByCategory(String category) {
    final allFoods = _foodBox.values.toList();
    if (category == '전체') return allFoods;
    return allFoods.where((f) => f.category == category).toList();
  }

  FoodItem getRandomFood(String category) {
    final foods = getFoodsByCategory(category);
    if (foods.isEmpty) throw Exception('음식 데이터가 없습니다.');
    foods.shuffle();
    return foods.first;
  }

  void toggleFavorite(FoodItem item) {
    item.isFavorite = !item.isFavorite;
    item.save();
  }

  List<FoodItem> getFavorites() {
    return _foodBox.values.where((item) => item.isFavorite).toList();
  }

  Future<void> addRecentFood(FoodItem food) async {
    final box = await Hive.openBox<FoodItem>('recentBox');
    // 중복 제거
    final existing = box.values.where((item) => item.name == food.name);
    for (var item in existing) {
      await box.delete(item.key);
    }
    await box.add(food);

    if (box.length > 10) {
      await box.deleteAt(0);
    }
  }
}
