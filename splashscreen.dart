import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ตั้งเวลาให้เปลี่ยนไปยังหน้า Login
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(252, 207, 85, 1.0),
      // เปลี่ยนสีพื้นหลังที่นี่
      body: Center(
        child: Image.asset(
            'assets/IMG_756.png'), // ให้แน่ใจว่าใช้เส้นทางที่ถูกต้อง
      ),
    );
  }
}
