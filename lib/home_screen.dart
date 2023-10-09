import 'package:flutter/material.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Deep Link App'),
      ),
      body: const Center(
        child: Text(
          'MY HOME PAGE',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
