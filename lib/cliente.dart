import 'package:flutter_cadastro_cliente_v1/database_helper.dart';

// Classe que representa um cliente
//https://medium.com/flutter-comunidade-br/orienta%C3%A7%C3%A3o-a-objetos-em-dart-16542b792eb9
class Cliente {
  // Atributos
  int _clienteId;
  String _nome;
  String _cpf;

  // Construtor (atributos privados não podem ser opcionais)
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
      DatabaseHelper.columnClienteId : getClienteId,
      DatabaseHelper.columnNome : getNome,
      DatabaseHelper.columnCpf  : getCpf
    };
    return row;
  }
}