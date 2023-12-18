import 'package:bs23_task/pages/repository_list_page/repository_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Brain Station 23 Task',
      home: const RepositoryListPage(),
    );
  }
}


