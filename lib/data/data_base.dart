import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'budget_database.db');
    print("Inicializando o banco de dados em $path"); // Adicionado print
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    print(
        "Criando tabelas orcamentos e comodos e objetos dos comodos"); // Adicionado print
    await db.execute('''
  CREATE TABLE orcamentos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    data TEXT
  )
''');

    await db.execute('''
  CREATE TABLE comodos (
      id INTEGER PRIMARY KEY,
      nome TEXT,
      orcamento_id INTEGER,
      FOREIGN KEY (orcamento_id) REFERENCES orcamentos(id)
  )
''');

    await db.execute('''
  CREATE TABLE objetos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    comodo_id INTEGER,
    orcamento_id INTEGER,
    largura REAL, 
    altura REAL,  
    codigo TEXT,  
    tecido TEXT,  
    valor_total_vista REAL,
    valor_total_prazo REAL,
    FOREIGN KEY (comodo_id) REFERENCES comodos(id)
  )
''');

    await db.execute('''
  CREATE TABLE eventos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    data TEXT,
    cep TEXT,
    rua TEXT,
    bairro TEXT, 
    cidade TEXT
  )
''');
  }

  Future<int> insertOrcamento(String nome) async {
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    Database db = await instance.database;
    print("Adicionando $nome ao banco de dados com a data: $formattedDate");
    int id =
        await db.insert('orcamentos', {'nome': nome, 'data': formattedDate});
    print("Orçamento inserido com ID: $id");
    return id;
  }

  // Função para inserir um novo item associado a um orçamento
  Future<int> insertComodo(String nome, int orcamentoId) async {
    print("Adicionando comodo $nome ao orcamento $orcamentoId");
    Database db = await instance.database;
    return await db
        .insert('comodos', {'nome': nome, 'orcamento_id': orcamentoId});
  }

  Future<int> insertObjeto(
      String nome,
      String comodoId,
      int orcamentoId,
      double largura,
      double altura,
      String codigo,
      String tecido,
      double valorTotalVista,
      double valorTotalPrazo) async {
    Database db = await instance.database;
    print(
        "Adicionando objeto $nome ao cômodo $comodoId no orçamento $orcamentoId");

    return await db.insert('objetos', {
      'nome': nome,
      'comodo_id': comodoId,
      'orcamento_id': orcamentoId,
      'largura': largura,
      'altura': altura,
      'codigo': codigo,
      'tecido': tecido,
      'valor_total_vista': valorTotalVista,
      'valor_total_prazo': valorTotalPrazo,
    });
  }

  // Função para obter todos os orçamentos
  Future<List<Map<String, dynamic>>> getOrcamentos() async {
    Database db = await instance.database;
    return await db.query('orcamentos', columns: ['nome', 'data']);
  }

  // Função para obter todos os itens de um orçamento específico
  Future<List<Map<String, dynamic>>> getComodosDoOrcamento(
      int orcamentoId) async {
    print("Obtendo comodos do orcamento $orcamentoId"); // Adicionado print
    Database db = await instance.database;
    return await db
        .query('comodos', where: 'orcamento_id = ?', whereArgs: [orcamentoId]);
  }

  Future<int> getOrcamentoIdPorNome(String nome) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'orcamentos',
      where: 'nome = ?',
      whereArgs: [nome],
    );
    if (result.isNotEmpty) {
      return result.first['id'];
    }
    return -1; // Retorna -1 se nenhum orçamento for encontrado
  }

  // Função para excluir um orçamento por ID
  Future<int> deleteOrcamento(int orcamentoId) async {
    print(
        "Removendo orcamento do banco de dados: $orcamentoId"); // Adicionado print
    Database db = await instance.database;
    return await db
        .delete('orcamentos', where: 'id = ?', whereArgs: [orcamentoId]);
  }

  Future<void> deleteComodo(int comodoId) async {
    print("Removendo comodo do banco de dados: $comodoId"); // Adicionado print
    Database db = await instance.database;
    await db.delete('comodos', where: 'id = ?', whereArgs: [comodoId]);
  }

  Future<int> deleteObjeto(int objetoId) async {
    print("Removendo objeto do banco de dados: $objetoId");
    Database db = await instance.database;
    return await db.delete('objetos', where: 'id = ?', whereArgs: [objetoId]);
  }

  Future<List<Map<String, dynamic>>> getObjetosDoComodo(String modelo,
      String comodoId, int orcamentoId, double largura, double altura, String codigo, String tecido, double valorTotalVista, double valorTotalPrazo) async {
    print("Obtendo objetos do cômodo $comodoId no orçamento $orcamentoId");
    Database db = await instance.database;

    // Inclua todas as colunas desejadas na lista 'columns'
    List<String> columns = [
      'nome',
      'comodo_id',
      'orcamento_id',
      'largura',
      'altura',
      'codigo',
      'tecido',
      'valor_total_vista',
      'valor_total_prazo'
    ];

    return await db.query('objetos',
        columns: columns,
        where: 'comodo_id = ? AND orcamento_id = ?',
        whereArgs: [comodoId, orcamentoId]);
  }

  Future<int> getcomodoativo(String nome) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'comodos',
      where: 'nome = ?',
      whereArgs: [nome],
    );
    if (result.isNotEmpty) {
      return result.first['id'];
    }
    return -1; // Retorna -1 se nenhum orçamento for encontrado
  }

  Future<int> updateObjeto(String objetoId, String novoNome) async {
    Database db = await instance.database;
    return await db.update('objetos', {'nome': novoNome},
        where: 'id = ?', whereArgs: [objetoId]);
  }

  Future<int> insertEvento(String title, String data, String cep, String rua,
      String bairro, String cidade) async {
    Database db = await instance.database;
    print(
        "Adicionando evento $title ao banco de dados com a data: $data, CEP: $cep, Rua: $rua, Bairro: $bairro, Cidade: $cidade");
    int id = await db.insert('eventos', {
      'title': title,
      'data': data,
      'cep': cep,
      'rua': rua, // Adicione estas linhas
      'bairro': bairro, // Adicione estas linhas
      'cidade': cidade // Adicione estas linhas
    });
    print(
        "Evento inserido com ID: $id, title: $title, data: $data, CEP: $cep, Rua: $rua, Bairro: $bairro, Cidade: $cidade");
    return id;
  }

  Future<List<Map<String, dynamic>>> getEventos() async {
    Database db = await instance.database;
    return await db.query('eventos');
  }

  Future<int> deleteEvento(int eventoId) async {
    print("Removendo evento do banco de dados: $eventoId");
    Database db = await instance.database;
    return await db.delete('eventos', where: 'id = ?', whereArgs: [eventoId]);
  }
}
