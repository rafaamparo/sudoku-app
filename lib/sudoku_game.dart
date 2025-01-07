import 'package:flutter/material.dart';
import 'package:sudoku/services/databaseService.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:tuple/tuple.dart';

class PagSudoku extends StatefulWidget {
  const PagSudoku(
      {super.key,
      this.dificuldadeSelecionada = 'easy',
      this.nome = 'abc',
      this.id = 0});
  final String dificuldadeSelecionada;
  final String nome;
  final int? id;
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
  late List<List<int>> matrizTemp;
  late List<List<int>> matrizSudoku;
  late List<List<int>> matrizSolucao;
  late List<Tuple2<int, int>> celulasVazias;
  late List<int> selecionado;
  final DatabaseService bancoDeDados = DatabaseService.instance;
  bool ganhouPrimeiraVez = false;
  List<List<int>> mexerNoValor(int value) {
    int i = selecionado[0];
    int j = selecionado[1];
    if (!celulasVazias.contains(Tuple2(i, j))) return matrizSudoku;
    setState(() {
      matrizSudoku[i][j] = value;
    });
    return matrizSudoku;
  }

  bool avermelhar(int quadrante, int indice) {
    int linha = (quadrante ~/ 3) * 3 + (indice ~/ 3);
    int coluna = (quadrante % 3) * 3 + (indice % 3);
    for (int i = 0; i < 9; i++) {
      if (matrizSudoku[quadrante][i] == matrizSudoku[quadrante][indice] &&
          i != indice &&
          matrizSudoku[quadrante][i] != -1) {
        return true;
      }
    }
    for (int c = 0; c < 9; c++) {
      if (matrizSudoku[linha ~/ 3 * 3 + c ~/ 3][c % 3 + linha % 3 * 3] ==
              matrizSudoku[quadrante][indice] &&
          c != coluna &&
          matrizSudoku[linha ~/ 3 * 3 + c ~/ 3][c % 3 + linha % 3 * 3] != -1) {
        return true;
      }
    }
    for (int r = 0; r < 9; r++) {
      if (matrizSudoku[r ~/ 3 * 3 + coluna ~/ 3][coluna % 3 + r % 3 * 3] ==
              matrizSudoku[quadrante][indice] &&
          r != linha &&
          matrizSudoku[r ~/ 3 * 3 + coluna ~/ 3][coluna % 3 + r % 3 * 3] !=
              -1) {
        return true;
      }
    }
    return false;
  }

  List<List<int>> processarMatriz(List<List<int>> matriz) {
    List<List<int>> sublistas = [];
    for (int i = 0; i < 9; i += 3) {
      List<int> bloco1 = [];
      List<int> bloco2 = [];
      List<int> bloco3 = [];
      for (int j = 0; j < 3; j++) {
        bloco1.addAll(matriz[i + j].sublist(0, 3));
        bloco2.addAll(matriz[i + j].sublist(3, 6));
        bloco3.addAll(matriz[i + j].sublist(6, 9));
      }
      sublistas.addAll([bloco1, bloco2, bloco3]);
    }
    return sublistas;
  }

  bool comparaMatrizes(List<List<int>> matriz1, List<List<int>> matriz2) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (matriz1[i][j] != matriz2[i][j]) {
          return false;
        }
      }
    }
    ;
    this.bancoDeDados.updateResultadoPartida(widget.id!, 1);
    return true;
  }

  @override
  void initState() {
    super.initState();
    selecionado = [-1, -1];
    nivel = getLevel(widget.dificuldadeSelecionada);
    Sudoku sudoku = Sudoku.generate(nivel);
    sudoku.debug();
    matrizTemp = List.generate(
        9, (i) => List.generate(9, (j) => sudoku.puzzle[i * 9 + j]));
    matrizSudoku = processarMatriz(matrizTemp);
    matrizSolucao = processarMatriz(List.generate(
        9, (i) => List.generate(9, (j) => sudoku.solution[i * 9 + j])));
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
          child: Column(children: [
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
                            physics: const ScrollPhysics(),
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
                                        ? const Color.fromARGB(255, 45, 68, 63)
                                        : avermelhar(matriz, indice)
                                            ? Colors.red
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
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: celulasVazias.contains(
                                                Tuple2(matriz, indice))
                                            ? const Color.fromARGB(
                                                255, 198, 190, 190)
                                            : Colors.black,
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
              spacing: 6,
              runSpacing: 8,
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
              height: 14,
            ),
            Wrap(
              spacing: 6,
              runSpacing: 8,
              children: [
                FilledButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(context);
                    },
                    child: const Text("Novo Jogo")),
                FilledButton(
                  onPressed: (!comparaMatrizes(matrizSudoku, matrizSolucao))
                      ? null
                      : () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Vitória!'),
                              content: const Text('Você venceu o jogo!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                  child: const Text('Verificar Vitória'),
                )
              ],
            )
          ]),
        ));
  }
}
