import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController controller1 = TextEditingController();
TextEditingController controller2 = TextEditingController();

final _formKey = GlobalKey<FormState>();

class CaixasTexto extends StatefulWidget {
  final Function(String) onTap;
  final String modeloSelecionado;

  CaixasTexto({Key? key, required this.onTap, required this.modeloSelecionado});

  @override
  State<CaixasTexto> createState() => _CaixasTexto();
}

class _CaixasTexto extends State<CaixasTexto> {
  bool containerVisible = false;
  bool codigoSelecionado = false;
  final Data _data = Data();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => screen_select_cod(
                            modeloSelecionado: widget.modeloSelecionado,
                          ),
                        ),
                      );
                      setState(() {
                        codigoSelecionado = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Código",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ),
          if (codigoSelecionado)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                height: 75,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Tecido: ${Data().tecidoSelecionado}\n Código: ${Data().codigoSelecionado}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (codigoSelecionado)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: TextFormField(
                  validator: (String? value) {
                    if (value != null && value.isEmpty || value == String) {
                      return 'Insira uma medida Correta';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      labelText: "Largura",
                      floatingLabelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: controller1,
                ),
              ),
            ),
          if (codigoSelecionado)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: TextFormField(
                  validator: (String? value) {
                    if (value != null && value.isEmpty || value == String) {
                      return 'Insira uma medida Correta';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      labelText: "Altura",
                      floatingLabelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: controller2,
                ),
              ),
            ),
          Column(
            children: [
              if (codigoSelecionado)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      double valor1 = double.parse(controller1.text);
                      double valor2 = double.parse(controller2.text);
                      _data.largura = valor1;
                      _data.altura = valor2;

                      double resultado = valor1 * valor2;
                      _data.Resultado = resultado;

                      toggleContainerVisibility();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Calcular",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (containerVisible)
                Container(
                  width: 300,
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Modelo Encontrado!\n",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Larg x Alt: ${_data.Resultado.toStringAsFixed(2)} metros \n Código: ${Data().codigoSelecionado} \n Tecido: ${Data().tecidoSelecionado} \n Preço Vísta: R\$${Data().precoVista.toStringAsFixed(2)} \n Preço Prazo: R\$${Data().precoPrazo.toStringAsFixed(2)} \n Preço Total Vísta: R\$${(Data().precoVista * Data().Resultado + (Data().precoVista * Data().Resultado) / 2).toStringAsFixed(2)}\n Preço Total Prazo: R\$${(Data().precoPrazo * Data().Resultado + (Data().precoPrazo * Data().Resultado / 2)).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.onTap(widget
                                  .modeloSelecionado); // Chama a função onTap fornecida
                              toggleContainerVisibility();
                              setState(() {
                                containerVisible = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            'Salvar',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            containerVisible = false; // Fecha o container
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Fechar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void toggleContainerVisibility() {
    setState(() {
      containerVisible = true;
    });
  }
}

class screen_select_cod extends StatefulWidget {
  final String modeloSelecionado;

  screen_select_cod({super.key, required this.modeloSelecionado});

  @override
  State<screen_select_cod> createState() => _screen_select_codState();
}

class _screen_select_codState extends State<screen_select_cod> {
  List<Widget> containersList = [];
  bool codigoSelecionado = false;
  final Data _data = Data();

  @override
  void initState() {
    super.initState();
    consultarDados();
  }

  void exibirMensagem(BuildContext context, String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
      duration: Duration(seconds: 2), // Define a duração da notificação
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> consultarDados() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('produtos')
          .where('Modelo', isEqualTo: widget.modeloSelecionado)
          .get();

      List<Widget> containers = [];

      for (var doc in querySnapshot.docs) {
        containers.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onLongPress: () {
                      String codigoSalvo = doc['codigo'];
                      if (codigoSalvo.length > 10) {
                        codigoSalvo = '${codigoSalvo.substring(0, 10)}...';
                      }
                      _data.codigoSelecionado = codigoSalvo;
                      String tecidoSalvo = doc['Tecido'];
                      if (tecidoSalvo.length > 10) {
                        tecidoSalvo = '${tecidoSalvo.substring(0, 10)}...';
                      }
                      _data.tecidoSelecionado = tecidoSalvo;
                      double precoVistaSalvo = doc['preco_vista'];
                      _data.precoVista = precoVistaSalvo;
                      double precoPrazoSalvo = doc['preco_prazo'];
                      _data.precoPrazo = precoPrazoSalvo;

                      print(
                          "Código: $codigoSalvo, Tecido: $tecidoSalvo, Preço Vista: $precoVistaSalvo, Preço Prazo: $precoPrazoSalvo");
                      exibirMensagem(context, 'Código Salvo $codigoSalvo');
                      setState(() {
                        codigoSelecionado = true;
                      });
                      Navigator.pop(context, {
                        'codigo': codigoSalvo,
                        'tecido': tecidoSalvo,
                        'precoVista': precoVistaSalvo,
                        'precoPrazo': precoPrazoSalvo,
                      });
                    },
                    child: Container(
                      width: 320,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2, color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Código: ${doc['codigo']}",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Tecido: ${doc['Tecido']} \n Preço à Vista: ${doc['preco_vista']} \n Preço a Prazo: ${doc['preco_prazo']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      setState(() {
        containersList = containers;
      });
    } catch (e) {
      print("Erro ao consultar dados: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Códigos do Modelo ${widget.modeloSelecionado}",
        ),
        titleTextStyle: const TextStyle(fontSize: 15),
        backgroundColor: const Color.fromARGB(255, 60, 0, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
              containersList, // Esta é a lista de containers gerada pela consulta
        ),
      ),
    );
  }
}

class Data {
  static final Data _instance = Data._internal();

  factory Data() {
    return _instance;
  }

  Data._internal();

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  double largura = 0;
  double altura = 0;
  double Resultado = 0;
  String codigoSelecionado = '';
  String tecidoSelecionado = '';
  double precoVista = 0;
  double precoPrazo = 0;
}
