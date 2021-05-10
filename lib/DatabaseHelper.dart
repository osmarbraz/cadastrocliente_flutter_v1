import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_cadastro_cliente_v1/Cliente.dart';

/*
 *  Os método são *Future" pois é usado para representar um valor potencial,
 *  ou erro, que estará disponível em algum momento no futuro.
 *  Usando um *Future*, podemos tratar os erros semelhantes ao esquema que *Try* e *Catch*.
 *
 *  Como estamos usando SQLite precisamos a biblioteca sqflite.
 *  A instalação da biblioteca deve ocorrer na pasta raíz  do projeto com o seguinte comando:
 *  $ flutter pub add sqflite
 *  Caso queira atualizar a versão, use o comando:
 *  $ flutter pub upgrade sqflite
 */
class DatabaseHelper {
  /**
   * Altere aqui os dados do seu banco de dados
   */
  static final _databaseName = "cliente.db";

  /**
   * Versão do banco de dados
   */
  static final _databaseVersion = 1;

  /**
   * String com o nome da tabela usada no banco
   */
  static final TABLE = 'CLIENTE';

  /**
   * Strings com as colunas da tabela
   */
  static final colunaClienteId = 'CLIENTEID';
  static final colunaNome = 'NOME';
  static final colunaCPF = 'CPF';

  /**
   * Abre o banco de dados e o cria a tabela se ela não existir e retorna o database
   */
  Future<Database> get getDatabase async {
    //Retorna o diretório do aplicativo
    Directory diretorioDocumentosAplicativo =
        await getApplicationDocumentsDirectory();
    //Caminho do banco de dados no aplicativo
    String caminhoBancoDados =
        join(diretorioDocumentosAplicativo.path, _databaseName);
    //Abre o banco de dados e cria se não existir
    Database database = await openDatabase(caminhoBancoDados,
        version: _databaseVersion, onCreate: _onCreate);
    //Retorna o database
    return database;
  }

  /**
   * Código para apagar o banco de dados e a tabela
   */
  Future apagarBancoDados() async {
    //Retorna o diretório do aplicativo
    Directory diretorioDocumentosAplicativo = await getApplicationDocumentsDirectory();
    //Caminho do banco de dados no aplicativo
    String caminhoBancoDados = join(diretorioDocumentosAplicativo.path, _databaseName);
    return await deleteDatabase(caminhoBancoDados);
  }

  /**
   * Código SQL para criar o banco de dados e a tabela
   */
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $TABLE (
            $colunaClienteId INTEGER PRIMARY KEY,
            $colunaNome  varchar(100) NOT NULL,
            $colunaCPF  varchar(11)
          )
          ''');
  }

  /**
   * Insere um registro no banco de dados
   */
  Future<int> incluir(Cliente cliente) async {
    Database db = await getDatabase;
    return await db.insert(TABLE, cliente.getMapColunasValores);
  }

  /**
   * Todas os registros são retornadas como uma lista de mapas, onde cada mapa é
   * uma lista de valores-chave de colunas.
   */
  Future<List<Map<String, dynamic>>> listaRegistros() async {
    Database db = await getDatabase;
    return await db.query(TABLE);
  }

  /**
   * Esse método usa uma consulta bruta para fornecer a contagem de registros.
   */
  Future<int> getNumeroRegistros() async {
    Database db = await getDatabase;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $TABLE'));
  }

  /**
   * Assumimos aqui que a coluna id no objeto está definida. Os outros
   * valores das colunas serão usados para atualizar a linha.
   */
  Future<int> alterar(Cliente cliente) async {
    Database db = await getDatabase;
    String id = cliente.getClienteId;
    return await db.update(TABLE, cliente.getMapColunasValores,
        where: '$colunaClienteId = ?', whereArgs: [id]);
  }

  /**
   *  Exclui a linha especificada pelo id. O número de registros afetadas
   *  retornada. Isso deve ser igual a 1, contanto que a linha exista.
   */
  Future<int> excluir(Cliente cliente) async {
    Database db = await getDatabase;
    return await db.delete(TABLE,
        where: '$colunaClienteId = ?', whereArgs: [cliente.getClienteId]);
  }

  /**
   * Retorna um objeto cliente a partir do id de um objeto
   */
  Future<Cliente> getCliente(Cliente cliente) async {
    Database db = await getDatabase;
    var res = await db.query(TABLE,
        where: '$colunaClienteId = ?', whereArgs: [cliente.getClienteId]);
    if (res.isNotEmpty) {
      Cliente cliente = new Cliente(
          res.first[DatabaseHelper.colunaClienteId],
          res.first[DatabaseHelper.colunaNome],
          res.first[DatabaseHelper.colunaCPF]);
      return cliente;
    }
  }
}
