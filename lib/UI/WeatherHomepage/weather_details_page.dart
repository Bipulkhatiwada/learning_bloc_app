import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String data;

  const SecondScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(data),
      ),
    );
  }
}
