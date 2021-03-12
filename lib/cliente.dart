import 'package:flutter_cadastro_cliente_v1/sqlite_cliente_metadados.dart';

/**
 * Classe do Modelo a ser persistido no banco de dados
 */
class Cliente {
  // Atributos
  int _clienteId;
  String _nome;
  String _cpf;

  /**
   *  Construtor (atributos privados não podem ser opcionais)
   */
  Cliente(this._clienteId, this._nome, this._cpf);

  // Getter e Setter do clienteId
  int get getClienteId {
    return _clienteId;
  }

  set setClienteId(int clienteId) {
    this._clienteId = clienteId;
  }

  // Getter e Setter do nome
  String get getNome {
    return _nome;
  }

  set setNome(String nome) {
    this._nome = nome;
  }

  // Getter e Setter do cpf
  String get getCpf {
    return _cpf;
  }

  set setCpf(String cpf) {
    this._cpf = cpf;
  }

  /**
   * No Map row é especificado o nome da coluna e o valor da coluna.
   */
  Map<String, dynamic> get getRow {
    Map<String, dynamic> row = {
      ClienteDAOMetadados.colunaClienteId: getClienteId,
      ClienteDAOMetadados.colunaNome: getNome,
      ClienteDAOMetadados.colunaCPF: getCpf
    };
    return row;
  }
}
