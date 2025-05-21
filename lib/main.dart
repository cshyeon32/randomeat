import 'package:random_eat/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/food_item.dart';
import 'package:random_eat/services/seed_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(FoodItemAdapter());

  await Hive.deleteBoxFromDisk('foodBox'); // 초기화

  final foodBox = await Hive.openBox<FoodItem>('foodBox');

  await seedData(foodBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
