import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recommender App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomePage(), 
    );
  }
}
