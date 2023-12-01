import 'package:cortinas/pages/caixas_texto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController controller1 = TextEditingController();
TextEditingController controller2 = TextEditingController();

final _formKey = GlobalKey<FormState>();

class CaixasTexto2 extends StatefulWidget {
  final Function(String) onTap;
  final String modeloSelecionado;

  CaixasTexto2(
      {Key? key, required this.onTap, required this.modeloSelecionado});

  @override
  State<CaixasTexto2> createState() => _CaixasTexto2();
}

class _CaixasTexto2 extends State<CaixasTexto2> {
  bool codigoSelecionado = false;
  bool tem_acessorios = false;
  final Data _data = Data();
  bool is_pressed = false;
  double valorfinalvista = 0;
  double valorfinalprazo = 0;

  void calcularEResultado() {
    if (_formKey.currentState!.validate()) {
      double valor1 = double.parse(controller1.text);
      double valor2 = double.parse(controller2.text);
      _data.largura = valor1;
      _data.altura = valor2;
      double resultado = valor1 * valor2;
      _data.Resultado = resultado;

      toggleContainerVisibility();
    }
  }

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
                        if (widget.modeloSelecionado == "Romana" ||
                            widget.modeloSelecionado == "Rolô" ||
                            widget.modeloSelecionado == "PV" ||
                            widget.modeloSelecionado == "PV BK" ||
                            widget.modeloSelecionado == "PH" ||
                            widget.modeloSelecionado == "PH Monocomando" ||
                            widget.modeloSelecionado == "PH Standard") {
                          tem_acessorios = true;
                        } else {
                          tem_acessorios = false;
                        }
                        codigoSelecionado = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Tecido: ${Data().tecidoSelecionado}\nCódigo: ${Data().codigoSelecionado}",
                        style: const TextStyle(color: Colors.white),
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
              if (tem_acessorios)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => screen_select_acessorios(
                              modeloSelecionado: widget.modeloSelecionado,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "Acessórios",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                ),
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

                      valorfinalvista = 0;
                      valorfinalprazo = 0;
                      for (var valor in _data.precototaldeacessoriosvista) {
                        valorfinalvista +=
                            valor; // Isso imprimirá cada valor na lista
                        print("Valor Vista: $valor");
                      }
                      for (var valor in _data.precototaldeacessoriosprazo) {
                        valorfinalprazo +=
                            valor; // Isso imprimirá cada valor na lista
                        print("Valor Prazo: $valor");
                      }

                      setState(() {
                        _data.valorfinalvistaAcessorio = valorfinalvista;
                        _data.valorfinalprazoAcessorio = valorfinalprazo;
                      });
                      print(valorfinalvista);
                      print(valorfinalprazo);

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
              if (_data.containerVisible)
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Larg x Alt: ${_data.Resultado.toStringAsFixed(2)} metros \nCódigo: ${Data().codigoSelecionado} \nTecido: ${Data().tecidoSelecionado} \nPreço Vísta: R\$${Data().precoVista.toStringAsFixed(2)} \nPreço Prazo: R\$${Data().precoPrazo.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      if (_data.listaacessorios.isNotEmpty)
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                is_pressed = true;
                              });
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                setState(() {
                                  is_pressed = false;
                                });
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const screen_listacessories_add(),
                                ),
                              );
                            },
                            onLongPress: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AnimatedContainer(
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.elasticInOut,
                                        width: is_pressed
                                            ? 95
                                            : 100, // Reduzindo temporariamente a largura
                                        height: is_pressed
                                            ? 20
                                            : 25, // Reduzindo temporariamente a altura
                                        decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Acessórios",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  ),
                                  const Icon(Icons.shopping_cart),
                                ],
                              ),
                            )),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total Vísta: R\$${(Data().precoVista * Data().Resultado + (Data().precoVista * Data().Resultado) / 2).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      if (_data.listaacessorios.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.amber, width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '+ Acessórios: R\$${_data.valorfinalvistaAcessorio.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.amber),
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Prazo: R\$${(Data().precoPrazo * Data().Resultado + (Data().precoPrazo * Data().Resultado / 2)).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ),
                      if (_data.listaacessorios.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.amber, width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '+ Acessórios: R\$${_data.valorfinalprazoAcessorio.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.amber),
                              ),
                            ),
                          ),
                        ),
                      if (_data.listaacessorios.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.green, width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Total Vísta: R\$${(Data().precoVista * Data().Resultado + (Data().precoVista * Data().Resultado) / 2 + _data.valorfinalvistaAcessorio).toStringAsFixed(2)} \n Total Prazo: R\$${(Data().precoPrazo * Data().Resultado + (Data().precoPrazo * Data().Resultado / 2 + _data.valorfinalprazoAcessorio)).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _data.containerVisible =
                                  false; // Fecha o container
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 0, 0),
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
                      )
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
      _data.containerVisible = true;
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
  List<Widget> containersListSearch = [];
  bool codigoSelecionado = false;
  final Data _data = Data();
  double containerWidth = 50;
  bool showTextField = false;
  bool showIconchevronright = false;
  TextEditingController controller_button_search = TextEditingController();
  bool isTextFilled = false;
  bool buttonpressed = false;

  @override
  void initState() {
    super.initState();
    consultarDados();
  }

  void exibirMensagem(BuildContext context, String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
      duration: const Duration(seconds: 2), // Define a duração da notificação
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
                  child: GestureDetector(
                    onTap: () {
                      // Lógica para o clique simples aqui
                      // Exemplo: exibir notificação de clique simples
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Segure para selecionar'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
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
                              style: const TextStyle(
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

  Future<void> consultarDados_text_formfield() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('produtos')
          .where('Modelo', isEqualTo: widget.modeloSelecionado)
          .where('Tecido',
              isGreaterThanOrEqualTo: controller_button_search.text)
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
                  child: GestureDetector(
                    onTap: () {
                      // Lógica para o clique simples aqui
                      // Exemplo: exibir notificação de clique simples
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Segure para selecionar'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
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
                              style: const TextStyle(
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
        containersListSearch = containers;
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
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: containerWidth,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            containerWidth = containerWidth == 50 ? 200 : 50;
                            showTextField = containerWidth == 200;
                            showIconchevronright = containerWidth == 200;
                          });
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        )),
                    if (showTextField)
                      Expanded(
                        child: TextField(
                          controller: controller_button_search,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Tecido",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          onChanged: (value) {
                            controller_button_search.value = TextEditingValue(
                                text: value.toUpperCase(),
                                selection: controller_button_search.selection);
                            setState(() {
                              // Atualiza o estado de showIconchevronright com base no texto digitado
                              showIconchevronright = value.isNotEmpty;
                            });
                          },
                        ),
                      ),
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                            consultarDados_text_formfield();

                            setState(() {
                              buttonpressed = true;
                            });
                          },
                          icon: Icon(
                            Icons.chevron_right,
                            color: showIconchevronright
                                ? Colors.blue
                                : Colors.white,
                          )),
                    )
                  ],
                ),
              ),
            ),
            if (buttonpressed)
              const Center(
                  child: Text(
                "Códigos Relacionados a Pesquisa",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
            if (buttonpressed && containersListSearch.isEmpty)
              const Text(
                "Não Encontrado",
                style: TextStyle(color: Colors.red),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  containersListSearch, // Esta é a lista de containers gerada pela consulta
            ),
            const Text(
              "Todos Códigos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  containersList, // Esta é a lista de containers gerada pela consulta
            ),
          ],
        ),
      ),
    );
  }
}

class screen_select_acessorios extends StatefulWidget {
  final String modeloSelecionado;

  const screen_select_acessorios({super.key, required this.modeloSelecionado});

  @override
  State<screen_select_acessorios> createState() =>
      _screen_select_acessoriosState();
}

class _screen_select_acessoriosState extends State<screen_select_acessorios> {
  List<Widget> containersList = [];
  List<Widget> containersListmotor = [];
  final Data _data = Data();
  String acessorios_modelo = '';
  String acessorios_modelo_motorizacao = '';

  @override
  void initState() {
    super.initState();
    consultarDados();
  }

  void exibirMensagem(BuildContext context, String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
      duration: const Duration(seconds: 2), // Define a duração da notificação
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> consultarDados() async {
    if (widget.modeloSelecionado == "Romana") {
      acessorios_modelo = "ACESSÓRIOS ROMANA";
      acessorios_modelo_motorizacao = "ACESSÓRIOS ROMANA (MOTORIZAÇÃO)";
    }
    if (widget.modeloSelecionado == "Rolô") {
      acessorios_modelo = "ACESSORIOS ROLO";
      acessorios_modelo_motorizacao = "ACESSORIOS ROLO (MOTORIZAÇÃO)";
    }
    if (widget.modeloSelecionado == "PH" ||
        widget.modeloSelecionado == "PH Monocomando" ||
        widget.modeloSelecionado == "PH Standard") {
      acessorios_modelo = "ACESSÓRIOS PH";
      acessorios_modelo_motorizacao = "";
    }
    if (widget.modeloSelecionado == "PV" ||
        widget.modeloSelecionado == "PV BK") {
      acessorios_modelo = "PV BK(ACESSÓRIOS)";
      acessorios_modelo_motorizacao == "";
    }
    try {
      QuerySnapshot querySnapshotacessorios = await FirebaseFirestore.instance
          .collection('acessorios')
          .where('Modelo', isEqualTo: acessorios_modelo)
          .get();

      QuerySnapshot querySnapshotmotorizacao = await FirebaseFirestore.instance
          .collection('acessorios')
          .where('Modelo', isEqualTo: acessorios_modelo_motorizacao)
          .get();

      List<Widget> containers = [];
      List<Widget> containersAcessorios = [];

      for (var doc in querySnapshotacessorios.docs) {
        containers.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Segure para selecionar'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    onLongPress: () {
                      String acessorioSalvo = doc['Acessório'];
                      if (acessorioSalvo.length > 20) {
                        acessorioSalvo =
                            '${acessorioSalvo.substring(0, 20)}...';
                      }
                      _data.acessorioSelecionado = acessorioSalvo;
                      double precoVistaSalvoAcess = doc['preco_vista'];
                      _data.precoVistaAcessorio = precoVistaSalvoAcess;
                      var precoPrazoSalvoAcess = doc['preco_prazo'];
                      _data.precoPrazoSalvoAcessorio = precoPrazoSalvoAcess;
                      setState(() {
                        _data.listaacessorios.add(
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 320,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 2, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Acessório: ${doc['Acessório']}",
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
                                        "Preço à Vista: ${doc['preco_vista']} \n Preço a Prazo: ${doc['preco_prazo']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        print(acessorioSalvo);
                        if (doc['Acessório'] ==
                            "BANDÔ - BRANCO / PRETO /  BEGE / CINZA / MARROM") {
                          double precoacessorioAdicionarvista =
                              (doc['preco_vista'] * _data.largura +
                                  (doc['preco_vista'] * _data.largura) / 2);
                          double precoacessorioAdicionarprazo =
                              (doc['preco_prazo'] * _data.largura +
                                  (doc['preco_prazo'] * _data.largura) / 2);
                          _data.precototaldeacessoriosvista
                              .add(precoacessorioAdicionarvista);
                          _data.precototaldeacessoriosprazo
                              .add(precoacessorioAdicionarprazo);
                        } else {
                          double precoacessorioAdicionarvista =
                              doc['preco_vista'] + (doc['preco_vista'] / 2);
                          double precoacessorioAdicionarprazo =
                              doc['preco_prazo'] + (doc['preco_prazo'] / 2);
                          _data.precototaldeacessoriosvista
                              .add(precoacessorioAdicionarvista);
                          _data.precototaldeacessoriosprazo
                              .add(precoacessorioAdicionarprazo);
                        }
                      });
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return warning_button_calcular();
                        },
                      );
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
                              "Acessório: ${doc['Acessório']}",
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
                              "Preço à Vista: ${doc['preco_vista']} \n Preço a Prazo: ${doc['preco_prazo']}",
                              style: const TextStyle(
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

      for (var doc in querySnapshotmotorizacao.docs) {
        containersAcessorios.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Lógica para o clique simples aqui
                      // Exemplo: exibir notificação de clique simples
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Segure para selecionar'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    onLongPress: () {
                      String acessorioSalvo = doc['Acessório'];
                      if (acessorioSalvo.length > 20) {
                        acessorioSalvo =
                            '${acessorioSalvo.substring(0, 20)}...';
                      }
                      _data.acessorioSelecionado = acessorioSalvo;
                      double precoVistaSalvoAcess = doc['preco_vista'];
                      _data.precoVistaAcessorio = precoVistaSalvoAcess;
                      var precoPrazoSalvoAcess = doc['preco_prazo'];
                      _data.precoPrazoSalvoAcessorio = precoPrazoSalvoAcess;
                      setState(() {
                        _data.listaacessorios.add(
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 320,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 2, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Acessório: ${doc['Acessório']}",
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
                                        "Preço à Vista: ${doc['preco_vista']} \n Preço a Prazo: ${doc['preco_prazo']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        print(acessorioSalvo);
                        if (acessorioSalvo ==
                            "BANDÔ - BRANCO / PRETO /  BEGE / CINZA / MARROM") {
                          double precoacessorioAdicionarvista =
                              (doc['preco_vista'] * _data.largura) +
                                  (doc['preco_vista'] / 2);
                          double precoacessorioAdicionarprazo =
                              (doc['preco_prazo'] * _data.largura) +
                                  (doc['preco_prazo'] / 2);
                          _data.precototaldeacessoriosvista
                              .add(precoacessorioAdicionarvista);
                          _data.precototaldeacessoriosprazo
                              .add(precoacessorioAdicionarprazo);
                        } else {
                          double precoacessorioAdicionarvista =
                              doc['preco_vista'] + (doc['preco_vista'] / 2);
                          double precoacessorioAdicionarprazo =
                              doc['preco_prazo'] + (doc['preco_prazo'] / 2);
                          _data.precototaldeacessoriosvista
                              .add(precoacessorioAdicionarvista);
                          _data.precototaldeacessoriosprazo
                              .add(precoacessorioAdicionarprazo);
                        }
                      });
                      Navigator.pop(context);
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
                              "Acessório: ${doc['Acessório']}",
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
                              "Preço à Vista: ${doc['preco_vista']} \n Preço a Prazo: ${doc['preco_prazo']}",
                              style: const TextStyle(
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
        containersListmotor = containersAcessorios;
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
          "Acessórios do Modelo ${widget.modeloSelecionado}",
        ),
        titleTextStyle: const TextStyle(fontSize: 15),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Todos Acessórios",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  containersList, // Esta é a lista de containers gerada pela consulta
            ),
            if (containersListmotor.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Acessórios (MOTORIZAÇÃO)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: containersListmotor,
            )
          ],
        ),
      ),
    );
  }
}

class screen_listacessories_add extends StatefulWidget {
  const screen_listacessories_add({super.key});

  @override
  State<screen_listacessories_add> createState() =>
      _screen_listacessories_addState();
}

class _screen_listacessories_addState extends State<screen_listacessories_add> {
  final Data _data = Data();
  double valorfinalvista = 0;
  double valorfinalprazo = 0;

  @override
  void initState() {
    super.initState();
    consultarPrecototalacessorios();
  }

  void consultarPrecototalacessorios() {
    valorfinalvista = 0;
    valorfinalprazo = 0;
    for (var valor in _data.precototaldeacessoriosvista) {
      valorfinalvista += valor; // Isso imprimirá cada valor na lista
      print("Valor Vista: $valor");
    }
    for (var valor in _data.precototaldeacessoriosprazo) {
      valorfinalprazo += valor; // Isso imprimirá cada valor na lista
      print("Valor Prazo: $valor");
    }

    setState(() {
      _data.valorfinalvistaAcessorio = valorfinalvista;
      _data.valorfinalprazoAcessorio = valorfinalprazo;
    });
    print(valorfinalvista);
    print(valorfinalprazo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Acessórios Adicionados",
        ),
        titleTextStyle: const TextStyle(fontSize: 15),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _data.listaacessorios.clear();
                _data.precototaldeacessoriosvista.clear();
                _data.precototaldeacessoriosprazo.clear();
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            child: const Icon(Icons.delete),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Lista de Acessórios",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (_data.listaacessorios.isEmpty)
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Lista vázia \nVolte para a tela inicial e adicione um! :D",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
          ..._data.listaacessorios,
          if (_data.listaacessorios.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Vista: R\$${valorfinalvista.toStringAsFixed(2)} \n Total Prazo: R\$${valorfinalprazo.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ),
        ],
      )),
    );
  }
}

class warning_button_calcular extends StatefulWidget {
  @override
  _warning_button_calcular createState() => _warning_button_calcular();
}

class _warning_button_calcular extends State<warning_button_calcular> {
  final Data _data = Data();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.check),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'O acessório foi adicionado com sucesso!',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          _data.acessorioSelecionado,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                      "Preço Vista: R\$${_data.precoVistaAcessorio.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Preço Prazo: R\$${_data.precoPrazoSalvoAcessorio.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Cerfique-se de clicar novamente no botão (CALCULAR) na tela principal, para que os preços atualizem",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(100),),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Calcular",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Fecha o modal quando o botão é pressionado
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }
}
