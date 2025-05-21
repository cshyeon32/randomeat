import 'package:hive/hive.dart';
import 'package:random_eat/models/food_item.dart';

Future<void> seedData(Box<FoodItem> box) async {
// final box = Hive.box<FoodItem>('foods');
  if (box.isEmpty) {
    await box.addAll([
      //한식
      FoodItem(
          name: '김치찌개',
          imageUrl:
              'https://i.pinimg.com/736x/2d/4a/89/2d4a89b3b0ebe202bd9bcdac3f3be36f.jpg',
          category: '한식'),
      FoodItem(
          name: '비빔밥',
          imageUrl:
              'https://i.pinimg.com/736x/32/b9/5f/32b95fc5d05e88ba409c5f26a3e70066.jpg',
          category: '한식'),
      FoodItem(
          name: '불고기',
          imageUrl:
              'https://i.pinimg.com/736x/20/ae/b9/20aeb917d02402b0bee80ab56ea36256.jpg',
          category: '한식'),
      FoodItem(
          name: '된장찌개',
          imageUrl:
              'https://i.pinimg.com/736x/56/96/84/569684690e7ee4580d5b160680cd9b4b.jpg',
          category: '한식'),
      FoodItem(
          name: '제육볶음',
          imageUrl:
              'https://i.pinimg.com/736x/0a/fe/be/0afebe521e842a7260aced2d25bed1db.jpg',
          category: '한식'),

      // 양식
      FoodItem(
          name: '파스타',
          imageUrl:
              'https://i.pinimg.com/736x/02/30/6c/02306c079d3ac66f4d5c291b65de8f54.jpg',
          category: '양식'),
      FoodItem(
          name: '스테이크',
          imageUrl:
              'https://i.pinimg.com/736x/1d/13/a4/1d13a4ace019dcd61a4ec10e889fc252.jpg',
          category: '양식'),
      FoodItem(
          name: '피자',
          imageUrl:
              'https://i.pinimg.com/736x/10/6c/6d/106c6da96e0ffa5a0c9841d810059a99.jpg',
          category: '양식'),
      FoodItem(
          name: '햄버거',
          imageUrl:
              'https://i.pinimg.com/736x/e4/cb/eb/e4cbeb5fb7453f1e9223924ac72f2151.jpg',
          category: '양식'),
      FoodItem(
          name: '리조또',
          imageUrl:
              'https://i.pinimg.com/736x/fa/d1/5c/fad15c522e259a33a733a8cc2b8c85ea.jpg',
          category: '양식'),

      // 기타
      FoodItem(
          name: '샐러드',
          imageUrl:
              'https://i.pinimg.com/736x/eb/cb/b9/ebcbb960d5d992314b90ba13029e05b3.jpg',
          category: '기타'),
      FoodItem(
          name: '샌드위치',
          imageUrl:
              'https://i.pinimg.com/736x/9e/00/07/9e00078d29c02713a5d1d0915a2f2fc6.jpg',
          category: '기타'),
      FoodItem(
          name: '볶음밥',
          imageUrl:
              'https://i.pinimg.com/736x/94/a4/74/94a474eb590014c632b82baaf7e14adc.jpg',
          category: '기타'),
      FoodItem(
          name: '오므라이스',
          imageUrl:
              'https://i.pinimg.com/736x/6f/cc/71/6fcc716eb82a309cbb1ce076d278fa42.jpg',
          category: '기타'),
      FoodItem(
          name: '카레',
          imageUrl:
              'https://i.pinimg.com/736x/47/52/05/4752051241f54c5bd3072b598a883726.jpg',
          category: '기타'),
    ]);
  }
}
