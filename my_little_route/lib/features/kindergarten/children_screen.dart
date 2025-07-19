import 'package:flutter/material.dart';

class ChildrenScreen extends StatelessWidget {
  const ChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("ChildrenScreen") ,),
      body: Center(child: Text("ChildrenScreen"),),
    );
  }
}