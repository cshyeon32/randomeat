import 'package:random_eat/components/login_text_field.dart';
import 'package:random_eat/const/theme.dart';
import 'package:random_eat/screens/home/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    void onLoginPress() async {
      if (!saveAndValidateForm()) {
        return;
      }
      String? message;
      try {
        // Simulate login success
        await Future.delayed(Duration(seconds: 1));
      } on DioException catch (e) {
        message = e.response?.data['message'] ?? '알수 없는 오류가 발생했습니다.';
      } catch (e) {
        message = '알 수 없는 오류가 발생 했습니다.';
      } finally {
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/img/logo2.png',
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              LoginTextField(
                onSaved: (String? val) {
                  email = val!;
                },
                validator: (String? val) {
                  if (val?.isEmpty ?? true) {
                    return '이메일을 입력해 주세요,';
                  }
                  RegExp reg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (!reg.hasMatch(val!)) {
                    return '이메일 형식이 올바르지 않습니다.';
                  }
                  return null;
                },
                hintText: '이메일',
              ),
              SizedBox(
                height: 8.0,
              ),
              LoginTextField(
                onSaved: (String? val) {
                  password = val!;
                },
                validator: (String? val) {
                  if (val?.isEmpty ?? true) {
                    return '비밀번호를 입력해주세요.';
                  }
                  if (val!.length < 4 || val!.length > 8) {
                    return '4~8';
                  }
                  return null;
                },
                hintText: '비밀번호',
                obscureText: true,
              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: SECONDARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  onRegisterPress();
                },
                child: Text('회원가입'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: SECONDARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () async {
                  onLoginPress();
                },
                child: Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool saveAndValidateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    formKey.currentState!.save();
    return true;
  }

  void onRegisterPress() async {
    if (!saveAndValidateForm()) {
      return;
    }
    String? message;
    try {
      // TODO: Implement register logic here
      // await provider.register(email: email, password: password);
    } on DioException catch (e) {
      message = e.response?.data['message'] ?? '알수 없는 오류가 발생 했습니다.';
    } finally {
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }
}
