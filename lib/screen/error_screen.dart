import 'package:flutter/material.dart';


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: const Center(
        child: Text('ErrorScreen'),
      ),
    );
  }
}
