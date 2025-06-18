import 'package:random_eat/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_eat/screens/profile/category_manager_screen.dart';
import 'package:random_eat/screens/profile/favorites_screen.dart';
import 'package:random_eat/screens/profile/profile_screen.dart';
import 'models/food_item.dart';
import 'package:random_eat/screens/food/list_screen.dart';
import 'package:random_eat/screens/food/add_screen.dart';
import 'package:random_eat/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FoodItemAdapter());
  await Hive.openBox<FoodItem>('foodBox');
  await Hive.openBox<String>('categoryBox');
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
        '/favorites': (context) => const FavoritesScreen(),
        '/add': (context) => const AddScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/category': (context) => const CategoryManagerScreen(),
      },
    );
  }
}
