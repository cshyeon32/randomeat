import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryManagerScreen extends StatefulWidget {
  const CategoryManagerScreen({super.key});

  @override
  State<CategoryManagerScreen> createState() => _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends State<CategoryManagerScreen> {
  final _controller = TextEditingController();
  late Box<String> _categoryBox;

  @override
  void initState() {
    super.initState();
    _categoryBox = Hive.box<String>('categoryBox');

    if (_categoryBox.isEmpty) {
      final defaultCategories = ['전체', '한식', '중식', '일식', '양식', '기타'];
      for (var category in defaultCategories) {
        _categoryBox.add(category);
      }
    }
  }

  void _addCategory() {
    final newCategory = _controller.text.trim();
    if (newCategory.isEmpty) return;
    if (_categoryBox.values.contains(newCategory)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 존재하는 카테고리입니다.')),
      );
      return;
    }
    _categoryBox.add(newCategory);
    _controller.clear();
    setState(() {});
  }

  void _deleteCategory(int index) {
    _categoryBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categoryBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('카테고리 관리')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '새 카테고리 추가',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ),
              onSubmitted: (_) => _addCategory(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isDefault =
                      ['전체', '한식', '중식', '일식', '양식', '기타'].contains(category);

                  return ListTile(
                    title: Text(category),
                    trailing: isDefault
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(index),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
