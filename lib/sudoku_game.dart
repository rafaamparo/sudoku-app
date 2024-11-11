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
  List<List<int>> mexerNoValor(int value) {
    int i = selecionado[0];
    int j = selecionado[1];
    if (!celulasVazias.contains(Tuple2(i, j))) return matrizSudoku;
    setState(() {
      matrizSudoku[i][j] = value;
    });
    return matrizSudoku;
  }

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Center(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                        ? const Color.fromARGB(
                                            255, 160, 225, 211)
                                        : celulasVazias.contains(
                                                Tuple2(matriz, indice))
                                            ? const Color.fromARGB(
                                                255, 255, 255, 255)
                                            : const Color.fromARGB(
                                                255, 224, 205, 217),
                                    alignment: Alignment.center,
                                    child: Text(
                                      matrizSudoku[matriz][indice] == -1
                                          ? ''
                                          : matrizSudoku[matriz][indice]
                                              .toString(),
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
            ),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              spacing: 5,
              runSpacing: 5,
              children: [
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        matrizSudoku = mexerNoValor(1);
                      });
                    },
                    child: const Text('1')),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        matrizSudoku = mexerNoValor(2);
                      });
                    },
                    child: const Text('2')),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        matrizSudoku = mexerNoValor(3);
                      });
                    },
                    child: const Text('3')),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        matrizSudoku = mexerNoValor(4);
                      });
                    },
                    child: const Text('4')),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        matrizSudoku = mexerNoValor(5);
                      });
                    },
                    child: const Text('5')),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        matrizSudoku = mexerNoValor(6);
                      });
                    },
                    child: const Text('6')),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        matrizSudoku = mexerNoValor(7);
                      });
                    },
                    child: const Text('7')),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        matrizSudoku = mexerNoValor(8);
                      });
                    },
                    child: const Text('8')),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        matrizSudoku = mexerNoValor(9);
                      });
                    },
                    child: const Text('9')),
                FilledButton(
                    onPressed: () {
                      setState(() {
                        mexerNoValor(-1);
                      });
                    },
                    child: const Icon(Icons.delete_outline_sharp)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FilledButton(onPressed: () {}, child: const Text("Novo Jogo"))
          ],
        )));
  }
}
