// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_application_assignment/View/Theme.dart';
import 'package:news_application_assignment/View/news_list_view.dart';
import 'package:news_application_assignment/View/splash_screen.dart';
import 'package:news_application_assignment/ViewController/news_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,  // Add this line
      title: 'News App',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put(NewsController());
      }),
    );
  }
}