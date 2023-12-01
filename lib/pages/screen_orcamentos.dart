import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortinas/data/data_base.dart';
import 'package:cortinas/pages/screen_comodos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class firsthomePage extends StatefulWidget {
  const firsthomePage({super.key});

  @override
  State<firsthomePage> createState() => _firsthomePageState();
}

class _firsthomePageState extends State<firsthomePage> {
  List<Widget> listaDeOrcamentos =
      []; // Adicionando uma lista para armazenar os orçamentos
  String novoOrcamento = "";
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  String dataAtual = "";

  @override
  void initState() {
    super.initState();
    obterOrcamentos();
    obterDataAtual();
  }

  void obterDataAtual() {
    setState(() {
      DateTime dataAtual = DateTime.now();
      print('Ano: ${dataAtual.year}');
      print('Mês: ${dataAtual.month}');
      print('Dia: ${dataAtual.day}');
    });
  }

  void obterOrcamentos() async {
    List<Map<String, dynamic>> orcamentos = await dbHelper.getOrcamentos();
    setState(() {
      for (var orcamento in orcamentos) {
        listaDeOrcamentos.add(criarNovoOrcamento(orcamento['nome']));
      }
    });
  }

  Future<DocumentReference> addMessageToGuestBook(String message) {
    //if (!_loggedIn) {
    //throw Exception('Must be logged in');
    //}

    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Widget criarNovoOrcamento(String texto) {
    UniqueKey uniqueKey = UniqueKey();
    return InkWell(
      onTap: () async {
        String nomeOrcamento = texto;
        int orcamentoId = await dbHelper.getOrcamentoIdPorNome(nomeOrcamento);
        if (orcamentoId != -1) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return SecondPage(
                title: texto,
                onDelete: () async {
                  try {
                    await DatabaseHelper.instance.deleteOrcamento(orcamentoId);
                    await DatabaseHelper.instance.deleteComodo(orcamentoId);
                  } catch (e) {
                    print('Erro ao excluir orçamento: $e');
                  }
                  setState(() {
                    listaDeOrcamentos
                        .removeWhere((widget) => widget.key == uniqueKey);
                  });
                  Navigator.pop(context);
                },
                orcamentoId: orcamentoId,
              );
            },
          ));
        } else {
          print('Orcamento não encontrado');
        }
      },
      key: uniqueKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          width: 300,
          height: 75,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text.rich(
              TextSpan(
                text: '$texto \n',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Data: $dataAtual',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 140, 255),
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void adicionarNovoOrcamento(String texto) async {
    await dbHelper.insertOrcamento(texto);

    setState(() {
      listaDeOrcamentos.add(criarNovoOrcamento(texto));
    });
  }

  // Adicionando uma variável para armazenar o novo orçamento
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Lista de Orçamentos",
          textAlign: TextAlign.center,
        ),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(
                        child: Text(
                      'Criar Orçamento',
                    )),
                    content: TextFormField(
                      maxLength: 25,
                      textAlign: TextAlign.center,
                      onChanged: (text) {
                        setState(() {
                          novoOrcamento = text;
                        });
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Fecha o pop-up
                        },
                        child: const Text(
                          'Fechar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          String roomName = novoOrcamento;

                          if (roomName.isNotEmpty) {
                            int orcamentoId =
                                await dbHelper.getOrcamentoIdPorNome(roomName);
                            if (orcamentoId != -1) {
                            } else {
                              adicionarNovoOrcamento(roomName);
                              Navigator.of(context).pop(); // Fecha o pop-up
                            }
                          } else {}

                          setState(() {
                            novoOrcamento = "";
                          });
                        },
                        child: const Text(
                          'Adicionar',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 37,
              decoration: const BoxDecoration(),
              child: SvgPicture.asset(
                'assets/icons/plus.svg',
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: listaDeOrcamentos,
          ),
        ),
      ),
    );
  }
}
