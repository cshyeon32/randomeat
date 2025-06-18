import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_eat/models/food_item.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedCategory = '전체';
  File? _imageFile;

  List<String> _categories = ['전체'];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final box = await Hive.openBox<String>('categoryBox');

    if (box.isEmpty) {
      await box.addAll(['한식', '양식', '중식', '일식', '기타']);
    }

    final values = box.values.toSet().toList();
    values.remove('전체');

    setState(() {
      _categories = ['전체', ...values];

      if (!_categories.contains(_selectedCategory)) {
        _selectedCategory = _categories.first;
      }
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _saveFood() async {
    if (_nameController.text.isEmpty || _imageFile == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final fileName = _imageFile!.path.split('/').last;
    final savedImage = await _imageFile!.copy('${directory.path}/$fileName');
    final foodBox = await Hive.openBox<FoodItem>('foodBox');
    final food = FoodItem(
      name: _nameController.text,
      imageUrl: savedImage.path,
      category: _selectedCategory.trim(),
    );

    await foodBox.add(food);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('음식 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '음식 이름'),
            ),
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
            ),
            const SizedBox(height: 10),
            _imageFile != null
                ? Image.file(_imageFile!, height: 100)
                : const Text('이미지 없음'),
            ElevatedButton(onPressed: _pickImage, child: const Text('이미지 선택')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveFood, child: const Text('저장')),
          ],
        ),
      ),
    );
  }
}
