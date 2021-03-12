import 'package:sqflite/sqflite.dart';
import 'package:flutter_cadastro_cliente_v1/cliente.dart';
import 'package:flutter_cadastro_cliente_v1/cliente_dao.dart';
import 'package:flutter_cadastro_cliente_v1/sqlite_cliente_metadados.dart';
import 'package:flutter_cadastro_cliente_v1/sqlite_dao_factory.dart';

/**
 *  Implementação do DAO para cliente com SQLite.
 */
class SqliteClienteDAO extends ClienteDAO {
  //Instância do banco a ser utilizado no DAO
  SQLiteDAOFactory sqlitedaofactory = new SQLiteDAOFactory();

  // Como a chamada dos métodos podem demorar são especificados como Future

  /**
   *   Construtor (atributos privados não podem ser opcionais)
   */
  SqliteClienteDAO() : super();

  /**
   * Insere um registro no banco de dados
   */
  Future<int> incluir(Cliente cliente) async {
    Database db = await sqlitedaofactory.getDatabase;
    return await db.insert(ClienteDAOMetadados.TABLE, cliente.getRow);
  }

  /**
   * Todas os registros são retornadas como uma lista de mapas, onde cada mapa é
   * uma lista de valores-chave de colunas.
   */
  Future<List<Map<String, dynamic>>> listaRegistros() async {
    Database db = await sqlitedaofactory.getDatabase;
    return await db.query(ClienteDAOMetadados.TABLE);
  }

  /**
   * Todos os métodos : inserir, consultar, atualizar e excluir,
   * também podem ser feitos usando  comandos SQL brutos.
   * Esse método usa uma consulta bruta para fornecer a contagem de registros.
   */
  Future<int> getQtdeRegistros() async {
    Database db = await sqlitedaofactory.getDatabase;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM ' + ClienteDAOMetadados.TABLE));
  }

  /**
   * Assumimos aqui que a coluna id no objeto está definida. Os outros
   * valores das colunas serão usados para atualizar a linha.
   */
  Future<int> alterar(Cliente cliente) async {
    Database db = await sqlitedaofactory.getDatabase;
    int id = cliente.getClienteId;
    return await db.update(ClienteDAOMetadados.TABLE, cliente.getRow,
        where: ClienteDAOMetadados.colunaClienteId + ' = ?', whereArgs: [id]);
  }

  /**
   *  Exclui a linha especificada pelo id. O número de registros afetadas
   *  retornada. Isso deve ser igual a 1, contanto que a linha exista.
   */
  Future<int> excluir(int id) async {
    Database db = await sqlitedaofactory.getDatabase;
    return await db.delete(ClienteDAOMetadados.TABLE,
        where: ClienteDAOMetadados.colunaClienteId + ' = ?', whereArgs: [id]);
  }

  /**
   *  Retorna um objeto cliente a partir do id
   */
  Future<Cliente> getCliente(int clienteId) async {
    Database db = await sqlitedaofactory.getDatabase;
    var res = await db.query(ClienteDAOMetadados.TABLE,
        where: ClienteDAOMetadados.colunaClienteId + ' = ?',
        whereArgs: [clienteId]);
    if (res.isNotEmpty) {
      Cliente cliente = new Cliente(
          res.first[ClienteDAOMetadados.colunaClienteId],
          res.first[ClienteDAOMetadados.colunaNome],
          res.first[ClienteDAOMetadados.colunaCPF]);
      return cliente;
    }
  }
}
