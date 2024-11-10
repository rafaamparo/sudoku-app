import 'package:flutter/material.dart';
import 'package:sudoku/sudoku_iniciar.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: const RootPage());
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const PagInicial(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 143, 87, 153),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
          title: const Text("Sudoku (Rafa's Version)"),
        ));
  }
}
