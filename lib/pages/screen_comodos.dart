import 'package:cortinas/pages/screen_listaPersianas.dart';
import 'package:cortinas/pages/data/data_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class SecondPage extends StatefulWidget {
  final String title;
  final Function onDelete;
  final int orcamentoId;

  const SecondPage({
    Key? key,
    required this.title,
    required this.onDelete,
    required this.orcamentoId,
  });

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class Room {
  final String name;
  final Widget container;

  Room({required this.name, required this.container});
}

class _SecondPageState extends State<SecondPage> {
  List<Room> rooms = [];
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  String roomName = "";

  @override
  void initState() {
    super.initState();
    int orcamentoIdDesejado = widget.orcamentoId;
    obterComodos(orcamentoIdDesejado);
  }

  void adicionarComodo(String roomName) async {
    try {
      if (roomName.isNotEmpty) {
        await dbHelper.insertComodo(roomName, widget.orcamentoId);

        List<Map<String, dynamic>> comodos =
            await dbHelper.getComodosDoOrcamento(widget.orcamentoId);

        setState(() {
          rooms = comodos.map((comodo) {
            return Room(
              name: comodo['nome'],
              container: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onDoubleTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return thirdhomePage(
                        title: comodo['nome'],
                        onDelete: () async {},
                        comodoId: comodo['nome'],
                        orcamentoId: widget.orcamentoId, // Passa o orcamentoId
                      );
                    }));
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comodo['nome'],
                              textAlign: TextAlign.start,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.menu,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList();
        });
      } else {
        print('O nome do cômodo está vazio');
      }
    } catch (e) {
      print("Erro ao adicionar cômodo: $e");
    }
  }

  void obterComodos(int orcamentoId) async {
    try {
      print("Orcamento ativo ID em obterComodos: $orcamentoId");
      List<Map<String, dynamic>> comodos =
          await dbHelper.getComodosDoOrcamento(orcamentoId);

      setState(() {
        rooms = comodos.map((comodo) {
          return Room(
              name: comodo['nome'],
              container: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return thirdhomePage(
                        title: comodo['nome'],
                        onDelete: () async {},
                        comodoId: comodo['nome'],
                        orcamentoId: widget.orcamentoId, // Passa o orcamentoId
                      );
                    }));
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comodo['nome'],
                              textAlign: TextAlign.start,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.menu,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        }).toList();
      });
    } catch (e) {
      print("Erro ao obter cômodos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 250,
                height: 25,
                child: Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                )),
            InkWell(
              onTap: () {
                widget.onDelete();
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/lixo.svg',
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // ignore: prefer_const_constructors
        backgroundColor: Color.fromARGB(255, 0, 0, 0), // Título da nova tela
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: "Criação de Orçamentos \n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Cômodos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              30, // Defina o tamanho de fonte desejado aqui
                          color: Colors.blue, // Defina a cor desejada aqui
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String roomName = "";
                      return AlertDialog(
                        title: const Text("Criar Cômodo",
                            textAlign: TextAlign.center),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              // Adiciona o TextField aqui
                              decoration: const InputDecoration(
                                hintText: 'Digite o nome do cômodo',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  roomName = value;
                                });
                              },
                            ),
                          ],
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: const Text(
                                  "Fechar",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                  onPressed: () async {
                                    adicionarComodo(roomName);

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Adicionar',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Icon(Icons.add),
              ),
            ),
            Container(
              width: 350,
              height: 500,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(179, 165, 165, 165),
                  borderRadius: BorderRadius.circular(30)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: rooms.map((room) => room.container).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
