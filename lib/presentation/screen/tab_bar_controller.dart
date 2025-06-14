import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/screen/home_screen.dart';
import 'package:noodle_timer/presentation/screen/recipe_history_screen.dart';
import 'package:noodle_timer/presentation/screen/search_screen.dart';
import 'package:noodle_timer/presentation/widget/home/custom_tab_bar.dart';

class TabBarController extends StatefulWidget {
  const TabBarController({super.key});

  @override
  State<TabBarController> createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {
  int _currentIndex = 1;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const SearchScreen(),
      const HomeScreen(),
      RecipeHistoryScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomTabBar(
        selectedIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
