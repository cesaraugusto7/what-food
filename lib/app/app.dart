import 'package:flutter/material.dart';
import 'package:whatfood/app/view/food_view.dart';
import 'package:whatfood/app/view/home_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatfood',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      routes: {
        '/': (context) => const HomeView(),
        '/food': (context) => const FoodView()
      },
    );
  }
}
