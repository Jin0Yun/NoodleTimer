import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '라면찾기',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}