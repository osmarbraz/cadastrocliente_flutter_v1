import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_cadastro_cliente_v1/sqlite_cliente_metadados.dart';
import 'package:flutter_cadastro_cliente_v1/sqlite_dados_banco.dart';

/**
 * Fabrica do banco SQLite.
 */
class SQLiteDAOFactory {
  /**
   * Abre o banco de dados e o cria se ele não existir
   */
  Future<Database> get getDatabase async {
    Directory diretorioDocumentosAplicativo =
        await getApplicationDocumentsDirectory();
    String caminhoBancoDados =
        join(diretorioDocumentosAplicativo.path, SQLiteDadosBanco.databaseName);
    Database database = await openDatabase(caminhoBancoDados,
        version: SQLiteDadosBanco.databaseVersion, onCreate: onCreateCliente);
    return database;
  }

  /**
   * Script de criação da tabela
   */
  Future onCreateCliente(Database db, int version) async {
    await db.execute('CREATE TABLE ' +
        ClienteDAOMetadados.TABLE +
        ' ( ' +
        ClienteDAOMetadados.colunaClienteId +
        ' INTEGER PRIMARY KEY, ' +
        ClienteDAOMetadados.colunaNome +
        ' varchar(100) NOT NULL, ' +
        ClienteDAOMetadados.colunaCPF +
        ' varchar(11) )');
  }

  /**
   * Código para apagar o banco de dados e a tabela
   */
  Future dropDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, SQLiteDadosBanco.databaseName);
    return await deleteDatabase(path);
  }
}
