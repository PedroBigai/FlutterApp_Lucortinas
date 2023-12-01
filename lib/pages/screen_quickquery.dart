import 'package:cortinas/pages/caixas_texto_quickquerry.dart';
import 'package:cortinas/data/data_base.dart';
import 'package:flutter/material.dart';

class screen_quick_query extends StatefulWidget {
  screen_quick_query({super.key});

  @override
  State<screen_quick_query> createState() => _screen_quick_queryState();
}

class _screen_quick_queryState extends State<screen_quick_query> {
  List<String> modelos = [
    'Romana',
    'Rolô',
    'PV',
    'PV BK',
    'PH',
    'PH Monocomando',
    'PH Standard',
    'DV Screen',
  ];

  Map<String, String> imagensModelos = {
    'Romana': 'assets/images/romana.jpeg',
    'Rolô': 'assets/images/rolo.jpeg',
    'PV': 'assets/images/pv.jpeg',
    'PV BK': 'assets/images/pv.jpeg',
    'PH': 'assets/images/ph.jpeg',
    'PH Monocomando': 'assets/images/ph2.jpg',
    'PH Standard': 'assets/images/ph3.jpg',
    'DV Screen': 'assets/images/dv.jpg',
  };

  List<Widget> listaDeContainers = [];
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  String modeloSelecionado = '';
  String modelo_adicionar = '';
  String? caminhoImagemModelo;

  Widget criarNovapersiana(
      String modelo,
      int orcamentoId,
      double largura,
      double altura,
      String codigo,
      String tecido,
      double valorTotalVista,
      double valorTotalPrazo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 350,
        height: 95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    modelo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Larg: $largura m \n Alt: $altura m",
                      style: const TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Código: $codigo \n Tecido: $tecido \n Total (Vista): R\$${(valorTotalVista * (largura * altura) + (valorTotalVista * (largura * altura) / 2)).toStringAsFixed(2)} \n Total (Prazo): R\$${(valorTotalPrazo * (largura * altura) + (valorTotalPrazo * (largura * altura) / 2)).toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void obterpersianas(
      String modelo,
      String comodoId,
      int orcamentoId,
      double largura,
      double altura,
      String codigo,
      String tecido,
      double valorTotalVista,
      double valorTotalPrazo) async {
    try {
      print(
          "Comodo ativo ID em obterpersianas: $comodoId no orçamento $orcamentoId");
      List<Map<String, dynamic>> persianas = await dbHelper.getObjetosDoComodo(
          modelo,
          comodoId,
          orcamentoId,
          largura,
          altura,
          codigo,
          tecido,
          valorTotalVista,
          valorTotalPrazo);

      setState(() {
        listaDeContainers = persianas.map((persiana) {
          // Acesse as informações adicionais da coluna conforme necessário
          String nome = persiana['nome'] ?? '';
          int orcamentoId =
              persiana['orcamento_id'] ?? 0; // Corrigir o nome da coluna
          double largura = persiana['largura'] ?? 0.0;
          double altura = persiana['altura'] ?? 0.0;
          String codigo = persiana['codigo'] ?? '';
          String tecido = persiana['tecido'] ?? '';
          double valorTotalVista = persiana['valor_total_vista'] ?? 0.0;
          double valorTotalPrazo = persiana['valor_total_prazo'] ?? 0.0;

          return criarNovapersiana(nome, orcamentoId, largura, altura, codigo,
              tecido, valorTotalVista, valorTotalPrazo);
        }).toList();
      });
    } catch (e) {
      print("Erro ao obter persianas: $e");
    }
  }

  void selecionarModelo(String modelo) {
    setState(() {
      modeloSelecionado = modelo;
      caminhoImagemModelo = imagensModelos[modelo];
    });
  }

  void adicionar(String modelo) {
    setState(() {
      if (modelo_adicionar == modelo) {
        // Se o modelo já está selecionado, torne-o vazio (empty)
        modelo_adicionar = '';
        modeloSelecionado = '';
      } else {
        modelo_adicionar = modelo;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 250,
              height: 25,
              child: Text(
                "Consulta Rápida",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 0, 54, 124),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Selecione",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      adicionar("Persiana");
                    },
                    child: Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 227, 227, 227),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/images/romana.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Text(
                            "Persiana",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      String modelo_adicionar = "Cortina";
                    },
                    child: Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 227, 227, 227),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/images/cortina.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Text(
                            "Cortina",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            if (modelo_adicionar == "Persiana")
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Selecione o Modelo",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ],
              ),
            if (modelo_adicionar == "Persiana")
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: modelos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onDoubleTap: () {
                            // Lógica para o double tap aqui
                            selecionarModelo(modelos[index]);
                          },
                          onTap: () {
                            // Lógica para o clique simples aqui
                            // Exemplo: exibir notificação de clique simples
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Toque 2 vezes para selecionar'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            width: 150,
                            decoration: BoxDecoration(
                              color: modelos[index] == modeloSelecionado
                                  ? const Color.fromARGB(255, 222, 240,
                                      255) // Cor do modelo selecionado
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      imagensModelos[modelos[index]]!,
                                      width: 100,
                                      height: 125,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    modelos[index], // Nome do modelo
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )),
            if (modeloSelecionado.isNotEmpty)
              Container(
                width: 350,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 234, 234, 234),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Modelo Selecionado!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              caminhoImagemModelo ?? '',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            modeloSelecionado, // Nome do modelo selecionado
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (modeloSelecionado.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 234, 234, 234),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CaixasTexto2(
                      onTap: (modelo) {},
                      modeloSelecionado: modeloSelecionado,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
