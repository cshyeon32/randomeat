import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:random_eat/models/food_item.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({Key? key}) : super(key: key);

  Widget buildImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(imagePath, height: 60, width: 60, fit: BoxFit.cover);
    } else {
      return Image.file(File(imagePath),
          height: 60, width: 60, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox<FoodItem>('recentBox'),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final box = snapshot.data as Box<FoodItem>;

        return Scaffold(
          appBar: AppBar(title: const Text("최근 추천 음식")),
          body: box.isEmpty
              ? const Center(child: Text("최근 추천 기록이 없습니다."))
              : ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final item = box.getAt(box.length - 1 - index); // 최신순
                    if (item == null) return const SizedBox.shrink();
                    return ListTile(
                      leading: buildImage(item.imageUrl),
                      title: Text(item.name),
                    );
                  },
                ),
        );
      },
    );
  }
}
