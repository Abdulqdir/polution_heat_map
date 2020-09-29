import 'package:flutter/material.dart';
import 'package:polutionheatmap/screens/Loading-screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black),
      home: LoadingScreen(),
    ),
  );
}
