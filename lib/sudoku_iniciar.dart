import 'package:flutter/material.dart';
import 'package:sudoku/sudoku_jogo.dart';

class PagInicial extends StatefulWidget {
  const PagInicial({super.key});

  @override
  State<PagInicial> createState() => _PagInicialState();
}

class _PagInicialState extends State<PagInicial> {
  String dificuldade = 'f';
  TextEditingController controladorNome = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Prepare-se para jogar!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Seu Nome',
                      ),
                      controller: controladorNome,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    RadioListTile(
                      value: 'fácil',
                      groupValue: dificuldade,
                      onChanged: (String? value) {
                        print("Radio: $value");
                        dificuldade = value!;

                        setState(() {});
                      },
                      title: const Text("Fácil"),
                    ),
                    RadioListTile(
                      value: 'médio',
                      groupValue: dificuldade,
                      onChanged: (String? value) {
                        print("Radio: $value");
                        dificuldade = value!;
                        setState(() {});
                      },
                      title: const Text("Médio"),
                    ),
                    RadioListTile(
                      value: 'difícil',
                      groupValue: dificuldade,
                      onChanged: (String? value) {
                        print("Radio: $value");
                        dificuldade = value!;

                        setState(() {});
                      },
                      title: const Text("Difícil"),
                    ),
                    RadioListTile(
                      value: 'expert',
                      groupValue: dificuldade,
                      onChanged: (String? value) {
                        print("Radio: $value");
                        dificuldade = value!;

                        setState(() {});
                      },
                      title: const Text("Expert"),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(
                        builder: (context) => PagJogo(
                              dificuldadeSelecionada: dificuldade,
                              nome: controladorNome.text,
                            )));
                  },
                  style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size(100, 50)),
                      backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 209, 154, 227))),
                  child: const Text('Novo Jogo',
                      style: TextStyle(color: Colors.white)),
                )
              ],
            )));
  }
}
