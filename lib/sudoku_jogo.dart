import 'package:flutter/material.dart';
import 'package:sudoku/models/jogo.dart';
import 'package:sudoku/services/databaseService.dart';
import 'package:sudoku/sudoku_game.dart';

class PagJogo extends StatelessWidget {
  const PagJogo(
      {super.key, this.dificuldadeSelecionada = 'f', this.nome = 'abc'});
  final String dificuldadeSelecionada;
  final String nome;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: JogoSudoku(
            dificuldadeSelecionada: dificuldadeSelecionada, nome: nome));
  }
}

class JogoSudoku extends StatefulWidget {
  const JogoSudoku(
      {super.key, this.dificuldadeSelecionada = 'f', this.nome = 'abc'});
  final String dificuldadeSelecionada;
  final String nome;
  @override
  State<JogoSudoku> createState() => _JogoSudokuState();
}

class _JogoSudokuState extends State<JogoSudoku> {
  get dificuldadeSelecionada => widget.dificuldadeSelecionada;
  get nome => widget.nome;
  final DatabaseService bancoDeDados = DatabaseService.instance;
  int? partidaId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createPartida();
    });
  }

  _createPartida() async {
    final mapDificuldade = {
      "fácil": 0,
      "médio": 1,
      "difícil": 2,
      "expert": 3,
    };

    Jogo partidaCriada = await bancoDeDados.addPartida(
        widget.nome, mapDificuldade[widget.dificuldadeSelecionada]!);

    setState(() {
      partidaId = partidaCriada.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 143, 87, 153),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
          title: Text(
              "${widget.nome} jogando! Dificuldade: ${widget.dificuldadeSelecionada}. ${partidaId != null ? '(id: $partidaId)' : ''}",
              style: const TextStyle(fontSize: 16)),
          automaticallyImplyLeading: true,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(context);
            },
          ),
        ),
        body: PagSudoku(
            dificuldadeSelecionada: dificuldadeSelecionada,
            nome: nome,
            id: partidaId));
  }
}
