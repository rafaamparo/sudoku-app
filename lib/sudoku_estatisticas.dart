import 'package:flutter/material.dart';
import 'package:sudoku/models/jogo.dart';
import 'package:sudoku/services/databaseService.dart';

class SudokuEstatisticas extends StatefulWidget {
  const SudokuEstatisticas({super.key});

  @override
  State<SudokuEstatisticas> createState() => _SudokuEstatisticasState();
}

class _SudokuEstatisticasState extends State<SudokuEstatisticas> {
  final DatabaseService bancoDeDados = DatabaseService.instance;
  int dificuldade = -1;
  List<Jogo> listaPartidas = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 87, 153),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        title: const Text("Game Stats", style: TextStyle(fontSize: 16)),
        automaticallyImplyLeading: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Filtre sua busca por dificuldade',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              DropdownButton<int>(
                value: dificuldade,
                items: const [
                  DropdownMenuItem(
                    value: -1,
                    child: Text('Todas'),
                  ),
                  DropdownMenuItem(
                    value: 0,
                    child: Text('Fácil'),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Médio'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('Difícil'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('Expert'),
                  ),
                ],
                onChanged: (value) async {
                  List<Jogo> dadosBD = await bancoDeDados.buscarPartidas(
                      dificuldade: dificuldade);
                  setState(() {
                    dificuldade = value!;
                    listaPartidas = dadosBD;
                  });
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Wrap(
                children: [
                  Text(
                      "Jogos vencidos: ${listaPartidas.where((element) => element.result == 1).length ?? 0}"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                      "Jogos perdidos: ${listaPartidas.where((element) => element.result == 0).length ?? 0}"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
