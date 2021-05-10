import 'package:flutter_cadastro_cliente_v1/DatabaseHelper.dart';

/**
 * Classe do Modelo a ser persistido no banco de dados
 */
class Cliente {
  // Atributos
  String _clienteId;
  String _nome;
  String _cpf;

  /**
  *  Construtor com parâmetros
  */
  Cliente(this._clienteId, this._nome, this._cpf);

  // Getter e Setter do clienteId
  String get getClienteId {
    return _clienteId;
  }

  set setClienteId(String clienteId) {
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
  Map<String, dynamic> get getMapColunasValores {
    Map<String, dynamic> row = {
      DatabaseHelper.colunaClienteId: getClienteId,
      DatabaseHelper.colunaNome: getNome,
      DatabaseHelper.colunaCPF: getCpf
    };
    return row;
  }

  /**
   * Retorna uma string com o estado do objeto.
   */
  @override
  String paraString() {
    return "clienteId :${this.getClienteId} - Nome :${this.getNome} - CPF :${this.getCpf}]";
  }
}
