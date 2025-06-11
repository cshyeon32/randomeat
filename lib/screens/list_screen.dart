import 'package:random_eat/components/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/food_item.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  Future<Box<FoodItem>> _openBox() async {
    if (!Hive.isBoxOpen('foodBox')) {
      return await Hive.openBox<FoodItem>('foodBox');
    }
    return Hive.box<FoodItem>('foodBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('음식 리스트'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          ),
        ],
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
          if (box.isEmpty) {
            return const Center(child: Text('등록된 음식이 없습니다.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final item = box.getAt(index);
              return ListTile(
                title: Text(item?.name ?? '이름 없음'),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
    );
  }
}
