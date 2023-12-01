import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cortinas/data/data_base.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  late int id;
  final String title;
  final DateTime data;
  final String cep;
  final String rua;
  final String bairro;
  final String cidade;

  Event(this.title, this.data, this.cep, this.rua, this.bairro, this.cidade);

  Event.withId(this.id, this.title, this.data, this.cep, this.rua, this.bairro,
      this.cidade);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'data': data.toIso8601String(),
      'cep': cep,
      'rua': rua,
      'bairro': bairro,
      'cidade': cidade,
    };
  }
}

class calendar extends StatefulWidget {
  calendar({super.key});

  @override
  State<calendar> createState() => _calendarState();
}

class _calendarState extends State<calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Event> eventos = [];

  TextEditingController nomeController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEventos();
  }

  Future<void> _loadEventos() async {
    List<Map<String, dynamic>> eventosFromDB = await dbHelper.getEventos();

    setState(() {
      eventos = eventosFromDB.map((evento) {
        return Event.withId(
          evento['id'],
          evento['title'],
          DateTime.parse(evento['data']),
          evento['cep'],
          evento['rua'],
          evento['bairro'],
          evento['cidade'],
        );
      }).toList();
    });
  }

  Future<void> consultarCEP(
      String cep,
      TextEditingController cepController,
      TextEditingController ruaController,
      TextEditingController bairroController,
      TextEditingController cidadeController) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        cepController.text = data['cep'];
        ruaController.text = data['logradouro'];
        bairroController.text = data['bairro'];
        cidadeController.text = data['localidade'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CEP não encontrado!'),
        ),
      );
    }
  }

  Widget _buildEventPopup() {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Adicionar Orçamento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Evento'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Deseja adicionar um endereço?",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.location_on),
                    ),
                    SizedBox(
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: cepController,
                          decoration: const InputDecoration(
                            labelText: 'CEP',
                            labelStyle: TextStyle(),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String cep = cepController.text;
                        await consultarCEP(cep, cepController, ruaController,
                            bairroController, cidadeController);
                      },
                      child: const Text('Consultar CEP'),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: ruaController,
                        decoration: const InputDecoration(labelText: 'Rua'),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: bairroController,
                        decoration: const InputDecoration(labelText: 'Bairro'),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: cidadeController,
                        decoration: const InputDecoration(labelText: 'Cidade'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (selectedDate != null) {
                selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (selectedTime != null) {
                  String nome = nomeController.text;
                  String cep = cepController.text;
                  String rua = ruaController.text; // Adicione estas linhas
                  String bairro = bairroController.text;
                  String cidade = cidadeController.text;

                  DateTime dataHora = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  Event novoEvento =
                      Event(nome, dataHora, cep, rua, bairro, cidade);

                  setState(() {
                    eventos.add(novoEvento);
                  });

                  int id = await dbHelper.insertEvento(
                    nome,
                    dataHora.toIso8601String(),
                    cepController.text,
                    ruaController.text, // Adicione estas linhas
                    bairroController.text,
                    cidadeController.text,
                  );

                  novoEvento.id = id;

                  dbHelper.insertEvento(
                    nome,
                    dataHora.toIso8601String(),
                    cepController.text,
                    ruaController.text, // Adicione estas linhas
                    bairroController.text,
                    cidadeController.text,
                  );

                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text('Marcar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    if (_selectedDay != null) {
      List<Event> eventosDoDia = eventos
          .where((evento) => isSameDay(evento.data, _selectedDay!))
          .toList();
      return Column(
        children: eventosDoDia.map((evento) {
          return InkWell(
            onDoubleTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            evento.title,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Data: ${evento.data.day}/${evento.data.month}/${evento.data.year}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Hora: ${evento.data.hour}:${evento.data.minute}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 350,
                            height: 150,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 233, 233, 233),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "CEP: ${evento.cep}\nRua: ${evento.rua}\nBairro: ${evento.bairro}\nCidade: ${evento.cidade}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await DatabaseHelper.instance
                                      .deleteEvento(evento.id);
                                  Navigator.of(context).pop(); // Fecha o modal
                                  _loadEventos(); // Atualiza a lista de eventos
                                } catch (e) {
                                  print('Erro ao excluir evento: $e');
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.red,
                                ),
                              ),
                              child: const Text('Deletar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Fecha o modal
                              },
                              child: const Text('Fechar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Data: ${evento.data.day}/${evento.data.month}/${evento.data.year}',
                  ),
                  Text(
                    'Hora: ${evento.data.hour}:${evento.data.minute}',
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Marcar Orçamento!",
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2101),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: (day) {
                return eventos.where((evento) {
                  return isSameDay(evento.data, day);
                }).toList();
              },
            ),
            _buildEventList(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildEventPopup();
                    },
                  );
                },
                child: const Text('Adicionar Orçamento'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
