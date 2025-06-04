import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:random_eat/components/custom_tab_bar.dart';
import 'package:random_eat/models/food_item.dart';
import 'package:random_eat/services/food_service.dart';
import 'package:random_eat/components/custom_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FoodService? _foodService;
  FoodItem? _food;
  String _selectedCategory = '전체';
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    if (!Hive.isBoxOpen('foodBox')) {
      await Hive.openBox<FoodItem>('foodBox');
    }

    final box = Hive.box<FoodItem>('foodBox');
    final service = FoodService(box);
    final categories = service.getCategories();

    setState(() {
      _foodService = service;
      _categories = categories;
      _food = _foodService!.getRandomFood(_selectedCategory);
    });
  }

  void _loadRandomFood() {
    setState(() {
      _food = _foodService!.getRandomFood(_selectedCategory);
    });
  }

  void _toggleFavorite() {
    setState(() {
      _foodService!.toggleFavorite(_food!);
    });
  }

  Widget buildImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // URL 이미지
      return Image.network(imagePath,
          height: 150, width: 150, fit: BoxFit.cover);
    } else {
      // 로컬 파일 이미지
      return Image.file(File(imagePath),
          height: 150, width: 150, fit: BoxFit.cover);
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
