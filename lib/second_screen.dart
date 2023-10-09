import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Deep Link App'),
      ),
      body: const Center(
        child: Text(
          'MY SECOND SCREEN 2ND',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
