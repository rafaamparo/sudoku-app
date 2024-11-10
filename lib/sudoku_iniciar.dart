import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class PagInicial extends StatefulWidget {
  const PagInicial({super.key});

  @override
  State<PagInicial> createState() => _PagInicialState();
}

class _PagInicialState extends State<PagInicial> {
  String? _radio1;
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
                const Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Seu Nome',
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    RadioListTile(
                      value: 'f',
                      groupValue: _radio1,
                      onChanged: (String? value) {
                        print("Radio: $value");
                        _radio1 = value;

                        setState(() {});
                      },
                      title: const Text("Fácil"),
                    ),
                    RadioListTile(
                      value: 'm',
                      groupValue: _radio1,
                      onChanged: (String? value) {
                        print("Radio: $value");
                        _radio1 = value;

                        setState(() {});
                      },
                      title: const Text("Médio"),
                    ),
                    RadioListTile(
                      value: 'd',
                      groupValue: _radio1,
                      onChanged: (String? value) {
                        print("Radio: $value");
                        _radio1 = value;

                        setState(() {});
                      },
                      title: const Text("Difícil"),
                    ),
                    RadioListTile(
                      value: 'e',
                      groupValue: _radio1,
                      onChanged: (String? value) {
                        print("Radio: $value");
                        _radio1 = value;

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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const PagJogo()),
                    // );
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
