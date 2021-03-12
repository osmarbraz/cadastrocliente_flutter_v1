import 'package:flutter_cadastro_cliente_v1/cliente.dart';

/**
 * Classe abstrata dos métodos do DAO para cliente
 */
abstract class ClienteDAO {
  // Como a chamada dos métodos podem demorar são especificados como Future

  Future<int> incluir(Cliente cliente);

  Future<List<Map<String, dynamic>>> listaRegistros();

  Future<int> getQtdeRegistros();

  Future<int> alterar(Cliente cliente);

  Future<int> excluir(int id);

  Future<Cliente> getCliente(int clienteId);
}
