import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:tuple/tuple.dart';

class PagSudoku extends StatefulWidget {
  const PagSudoku(
      {super.key, this.dificuldadeSelecionada = 'easy', this.nome = 'abc'});
  final String dificuldadeSelecionada;
  final String nome;

  @override
  State<PagSudoku> createState() => _PagSudokuState();
}

class _PagSudokuState extends State<PagSudoku> {
  Level getLevel(String dificuldade) {
    switch (dificuldade) {
      case 'fácil':
        return Level.easy;
      case 'médio':
        return Level.medium;
      case 'difícil':
        return Level.hard;
      case 'expert':
        return Level.expert;
      default:
        return Level.easy;
    }
  }

  late Level nivel;
  late List<List<int>> matrizSudoku;
  late List<Tuple2<int, int>> celulasVazias;
  late List<int> selecionado;

  @override
  void initState() {
    super.initState();
    selecionado = [-1, -1];
    nivel = getLevel(widget.dificuldadeSelecionada);
    Sudoku sudoku = Sudoku.generate(nivel);
    sudoku.debug();
    matrizSudoku = List.generate(
        9, (i) => List.generate(9, (j) => sudoku.puzzle[i * 9 + j]));
    celulasVazias = [];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (matrizSudoku[i][j] == -1) {
          celulasVazias.add(Tuple2(i, j));
        }
      }
    }
  }

  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: GridView.builder(
                itemCount: 9,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext, matriz) {
                  return Container(
                      padding: const EdgeInsets.all(2),
                      color: matriz % 2 == 0
                          ? const Color.fromARGB(255, 98, 81, 120)
                          : const Color.fromARGB(255, 109, 180, 222),
                      alignment: Alignment.center,
                      child: GridView.builder(
                        itemCount: 9,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        physics: ScrollPhysics(),
                        itemBuilder: (BuildContext, indice) {
                          return InkWell(
                              onTap: () {
                                print('Matriz: $matriz, Indice: $indice');
                                setState(() {
                                  if (celulasVazias
                                      .contains(Tuple2(matriz, indice))) {
                                    selecionado = [matriz, indice];
                                  }
                                });
                              },
                              child: Container(
                                color: selecionado[0] == matriz &&
                                        selecionado[1] == indice
                                    ? const Color.fromARGB(255, 160, 225, 211)
                                    : Colors.white,
                                alignment: Alignment.center,
                                child: Text(
                                  matrizSudoku[matriz][indice] == -1
                                      ? ''
                                      : matrizSudoku[matriz][indice].toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ));
                        },
                      ));
                },
              )),
        )
      ],
    ));
  }
}
