import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:risetech_smart_os/views/budget_view.dart';
import 'package:risetech_smart_os/views/closure_view.dart';
import 'package:risetech_smart_os/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RiseTech OS Organizze',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
