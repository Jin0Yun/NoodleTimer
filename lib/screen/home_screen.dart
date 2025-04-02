import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: const Center(
          child: Column(
            children: [
              Text('라면 타이머')
            ],
          ),
        ),
      ),
    );
  }
}
