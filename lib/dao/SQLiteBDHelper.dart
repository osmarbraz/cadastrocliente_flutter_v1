import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_cadastro_cliente_v1/dao/SQLiteDadosBanco.dart';
import 'package:flutter_cadastro_cliente_v1/dao/cliente/SQLiteClienteMetaDados.dart';

class SQLiteBDHelper implements SQLiteDadosBanco {
  /**
   * Abre o banco de dados e o cria a tabela se ela não existir e retorna o database
   */
  Future<Database> get getDatabase async {
    //Retorna o diretório do aplicativo
    Directory diretorioDocumentosAplicativo =
        await getApplicationDocumentsDirectory();
    //Caminho do banco de dados no aplicativo
    String caminhoBancoDados =
        join(diretorioDocumentosAplicativo.path, SQLiteDadosBanco.databaseName);
    //Abre o banco de dados e cria se não existir
    Database database = await openDatabase(caminhoBancoDados,
        version: SQLiteDadosBanco.databaseVersion,
        onCreate: (Database db, int version) async {
      await db.execute(SQLiteClienteMetaDados.METADADOSCREATE);
    });
    //Retorna o database
    return database;
  }

  /**
   * Código para apagar o banco de dados e a tabela
   */
  Future apagarBancoDados() async {
    //Retorna o diretório do aplicativo
    Directory diretorioDocumentosAplicativo =
        await getApplicationDocumentsDirectory();
    //Caminho do banco de dados no aplicativo
    String caminhoBancoDados =
        join(diretorioDocumentosAplicativo.path, SQLiteDadosBanco.databaseName);
    //Apaga o banco de dados
    return await deleteDatabase(caminhoBancoDados);
  }
}
