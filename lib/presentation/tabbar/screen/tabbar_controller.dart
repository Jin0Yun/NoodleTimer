import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/home/screen/home_screen.dart';
import 'package:noodle_timer/presentation/history/screen/recipe_history.dart';
import 'package:noodle_timer/presentation/search/screen/search_screen.dart';
import 'package:noodle_timer/presentation/tabbar/widget/custom_tab_bar.dart';

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
