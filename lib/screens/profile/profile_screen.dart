import 'dart:io';
import 'package:flutter/material.dart';
import 'package:random_eat/components/custom_tab_bar.dart';
import 'package:random_eat/screens/profile/favorites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<String?> _getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  @override
  Widget build(BuildContext context) {
    final String? profileImagePath = null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        centerTitle: true,
      ),
      body: FutureBuilder<String?>(
        future: _getEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final email = snapshot.data ?? '이메일 정보 없음';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 프로필 이미지
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImagePath != null
                      ? FileImage(File(profileImagePath))
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 16),

                // 이메일 표시
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // 버튼들
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('즐겨찾기'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const FavoritesScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('설정'),
                  onTap: () {
                    // TODO: 설정 화면으로 이동
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('로그아웃'),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('user_email');
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }
}
