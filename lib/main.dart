import 'package:flutter/material.dart';

void main() {
  runApp(const NumberSenseApp());
}

class NumberSenseApp extends StatelessWidget {
  const NumberSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFDA291C),
        body: const Center(
          child: Text(
            'NumberSense',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
