import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cadastro_cliente_v1/cliente.dart';

class DatabaseHelper {
  static final _databaseName = "cliente.db";
  static final _databaseVersion = 1;
  static final table = 'CLIENTE';
  static final columnClienteId = 'CLIENTEID';
  static final columnNome = 'NOME';
  static final columnCpf = 'CPF';

  // torna esta classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // tem somente uma referência ao banco de dados
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // instancia o db na primeira vez que for acessado
    _database = await _initDatabase();
    return _database;
  }
  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future dropDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await deleteDatabase(path);
  }

  // Código SQL para criar o banco de dados e a tabela
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnClienteId INTEGER PRIMARY KEY,
            $columnNome  varchar(100) NOT NULL,
            $columnCpf  varchar(11)
          )
          ''');
  }


  // Insere um registro no banco de dados
  // O valor de retorno é o id da linha inserida.
  Future<int> incluir(Cliente cliente) async {
    Database db = await instance.database;
    return await db.insert(table, cliente.getRow);
  }

  // Todas os registros são retornadas como uma lista de mapas, onde cada mapa é
  // uma lista de valores-chave de colunas.
  Future<List<Map<String, dynamic>>> listaRegistros() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Todos os métodos : inserir, consultar, atualizar e excluir,
  // também podem ser feitos usando  comandos SQL brutos.
  // Esse método usa uma consulta bruta para fornecer a contagem de registros.
  Future<int> getQtdeRegistros() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // Assumimos aqui que a coluna id no objeto está definida. Os outros
  // valores das colunas serão usados para atualizar a linha.
  Future<int> alterar(Cliente cliente) async {
    Database db = await instance.database;
    int id = cliente.getClienteId;
    return await db.update(table, cliente.getRow, where: '$columnClienteId = ?', whereArgs: [id]);
  }

  // Exclui a linha especificada pelo id. O número de registros afetadas é
  // retornada. Isso deve ser igual a 1, contanto que a linha exista.
  Future<int> excluir(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnClienteId = ?', whereArgs: [id]);
  }

  //Retorna um objeto cliente a partir do id
  Future<Cliente> getClient(int clienteId) async {
    Database db = await instance.database;
    var res = await db.query(
        table, where: '$columnClienteId = ?', whereArgs: [clienteId]);
    //var res = await db.rawQuery("SELECT $columnClienteId, $columnNome, $columnCpf FROM $table where $columnClienteId = " + clienteId.toString());
    if (res.isNotEmpty) {
      Cliente cliente = new Cliente(res.first[DatabaseHelper.columnClienteId],
          res.first[DatabaseHelper.columnNome],
          res.first[DatabaseHelper.columnCpf]);
      return cliente;
    }
  }
}