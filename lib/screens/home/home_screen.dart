import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_eat/components/custom_tab_bar.dart';
import 'package:random_eat/models/food_item.dart';
import 'package:random_eat/services/food_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FoodService? _foodService;
  FoodItem? _food;
  String _selectedCategory = '전체';
  List<String> _categories = ['전체'];

  @override
  void initState() {
    super.initState();
    _loadRandomFood();
    _initData();
  }

  Future<void> _initData() async {
    if (!Hive.isBoxOpen('foodBox')) {
      await Hive.openBox<FoodItem>('foodBox');
    }
    if (!Hive.isBoxOpen('categoryBox')) {
      await Hive.openBox<String>('categoryBox');
    }

    final foodBox = Hive.box<FoodItem>('foodBox');
    final service = FoodService(foodBox);

    final categoryBox = Hive.box<String>('categoryBox');
    final categories = categoryBox.values.toSet().toList();
    categories.remove('전체');

    final sorted = ['전체', ...categories];

    setState(() {
      _foodService = service;
      _categories = sorted;
      _food = _foodService!.getRandomFood(_selectedCategory);
    });
  }

  void _loadRandomFood() async {
    final newFood = _foodService!.getRandomFood(_selectedCategory);
    setState(() {
      _food = newFood;
    });
    await _foodService!.addRecentFood(newFood);
  }

  void _toggleFavorite() {
    setState(() {
      _foodService!.toggleFavorite(_food!);
    });
  }

  Widget buildImage(String imagePath) {
    final file = File(imagePath);
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(imagePath,
          height: 150, width: 150, fit: BoxFit.cover);
    } else {
      return file.existsSync()
          ? Image.file(file, height: 150, width: 150, fit: BoxFit.cover)
          : const Text('이미지를 불러올 수 없습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_foodService == null || _food == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("랜덤 음식 추천"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                        _loadRandomFood();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              buildImage(_food!.imageUrl),
              const SizedBox(height: 16),
              Text(
                _food!.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: Icon(
                  _food!.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _food!.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: _toggleFavorite,
              ),
              ElevatedButton(
                onPressed: _loadRandomFood,
                child: const Text("다른 음식 추천받기"),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
    );
  }
}
