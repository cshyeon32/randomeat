import 'package:random_eat/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_eat/screens/profile/profile_screen.dart';
import 'models/food_item.dart';
import 'package:random_eat/services/seed_data.dart';
import 'package:random_eat/screens/list_screen.dart';
import 'package:random_eat/screens/add_screen.dart';
import 'package:random_eat/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // await Hive.openBox('foodBox');
  Hive.registerAdapter(FoodItemAdapter());
  final foodBox = await Hive.openBox<FoodItem>('foodBox');
  await seedData(foodBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RandomEat',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/list': (context) => const ListScreen(),
        '/add': (context) => const AddScreen(),
        '/profile': (context) => const ProfileScreen(),
        // 필요한 다른 라우트도 추가 가능
      },
    );
  }
}
