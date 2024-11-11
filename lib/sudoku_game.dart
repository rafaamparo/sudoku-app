import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class PagSudoku extends StatefulWidget {
  const PagSudoku(
      {super.key, this.dificuldadeSelecionada = 'easy', this.nome = 'abc'});
  final String dificuldadeSelecionada;
  final String nome;

  @override
  State<PagSudoku> createState() => _PagSudokuState();
}

class _PagSudokuState extends State<PagSudoku> {
  Sudoku sudoku = Sudoku.generate(Level.medium);
  @override
  Widget build(BuildContext context) {
    sudoku.debug();
    List<List<int>> matrix = List.generate(
        9, (i) => List.generate(9, (j) => sudoku.puzzle[i * 9 + j]));

    return Center(
        child: Column(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Sudoku'),
              const SizedBox(width: 20),
              Text('Dificuldade: ${widget.dificuldadeSelecionada}'),
              const SizedBox(width: 20),
              Text('Jogador: ${widget.nome}'),
            ]),
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
                      padding: const EdgeInsets.all(5),
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
                          return Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Text(
                              matrix[matriz][indice] == -1
                                  ? ''
                                  : matrix[matriz][indice].toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ));
                },
              )),
        )
      ],
    ));
  }
}
