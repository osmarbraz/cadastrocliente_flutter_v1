import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cadastro_cliente_v1/database_helper.dart';
import 'package:flutter_cadastro_cliente_v1/cliente.dart';

//Programa principal
void main() {
  runApp(new MeuAplicativo());
}

class MeuAplicativo extends StatelessWidget {
  // Este widget é a raiz do aplicativo.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cadastro de Cliente v1',
      theme: new ThemeData(
        // Este é o tema do aplicativo.
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MinhaHomePage(),
    );
  }
}

// Este widget é a página inicial do seu aplicativo.
class MinhaHomePage extends StatefulWidget {
  MinhaHomePage({Key key}) : super(key: key);

  @override
  _MinhaHomePageState createState() => new _MinhaHomePageState();
}

class _MinhaHomePageState extends State<MinhaHomePage> {
  // referencia nossa classe single para gerenciar o banco de dados
  final dbHelper = DatabaseHelper.instance;

  //Mensagem com a quantidade de registros
  String mensagemRegistros = "Registros: 0";

  //Mensagem com os dados da tabela
  String mensagemDados = "";

  //Chave do formulário
  GlobalKey<FormState> chaveFormulario = GlobalKey<FormState>();

  //Controler das caixas de texto do formulário
  TextEditingController clienteIdController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();

  //Foco para o campo do clienteId
  FocusNode clienteIdFocus = new FocusNode();

  /**
   * Construtor
   */
  @override
  void initState() {
    super.initState();
    limparClick();
    atualizarRegistros();
  }

  /**
   * Destrutor
   */
  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    //Barra do aplicativo
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Cadastro de Cliente v1'),
      ),
      //Corpo do aplicativo
      body: Container(
        child: Builder(
            builder: (context) => Form(
              //Chave do formulário
              key: chaveFormulario,
              //Campos do formulário
              //Coluna dos campos de entrada
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  "ClienteId",
                                  style: new TextStyle(
                                      fontSize: 14.0, fontFamily: "Roboto"),
                                ),
                                SizedBox(
                                    width: 75,
                                    height: 25,
                                    child: new TextFormField(
                                        focusNode: clienteIdFocus,
                                        style: new TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Roboto"),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <
                                            TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly
                                        ],
                                        // somente números podem ser digitados
                                        //Validação da entrada
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Insira o clienteId!";
                                          }
                                        },
                                        controller: clienteIdController)),
                                new Text(
                                  "Nome Cliente",
                                  style: new TextStyle(
                                      fontSize: 14.0, fontFamily: "Roboto"),
                                ),
                                SizedBox(
                                    width: 200,
                                    height: 30,
                                    child: new TextFormField(
                                        style: new TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Roboto"),
                                        //Validação da entrada
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Insira o nome do cliente!";
                                          }
                                        },
                                        controller: nomeController)),
                                new Text(
                                  "CPF Cliente",
                                  style: new TextStyle(
                                      fontSize: 14.0, fontFamily: "Roboto"),
                                ),
                                SizedBox(
                                    width: 150,
                                    height: 30,
                                    child: new TextFormField(
                                        style: new TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Roboto"),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <
                                            TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly
                                        ],
                                        // somente números podem ser digitados
                                        //Validação da entrada
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Insira o cpf do cliente!";
                                          }
                                        },
                                        controller: cpfController)),
                                new Text(
                                  mensagemRegistros,
                                  style: new TextStyle(
                                      fontSize: 14.0, fontFamily: "Roboto"),
                                ),
                              ]),

                          //Coluna dos botões
                          new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new ElevatedButton(
                                    key: null,
                                    onPressed: incluirClick,
                                    child: new Text(
                                      "INCLUIR",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: "Roboto"),
                                    )),
                                new ElevatedButton(
                                    key: null,
                                    onPressed: alterarClick,
                                    child: new Text(
                                      "ALTERAR",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: "Roboto"),
                                    )),
                                new ElevatedButton(
                                    key: null,
                                    onPressed: excluirClick,
                                    child: new Text(
                                      "EXCLUIR",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: "Roboto"),
                                    )),
                                new ElevatedButton(
                                    key: null,
                                    onPressed: consultarClick,
                                    child: new Text(
                                      "CONSULTAR",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: "Roboto"),
                                    )),
                                new ElevatedButton(
                                    key: null,
                                    onPressed: listarClick,
                                    child: new Text(
                                      "LISTAR",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: "Roboto"),
                                    )),
                                new ElevatedButton(
                                    key: null,
                                    onPressed: esvaziarBDClick,
                                    child: new Text(
                                      "ESVAZIAR BD",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: "Roboto"),
                                    )),
                                new ElevatedButton(
                                    key: null,
                                    onPressed: limparClick,
                                    child: new Text(
                                      "LIMPAR",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: "Roboto"),
                                    )),
                                new ElevatedButton(
                                    key: null,
                                    onPressed: fecharClick,
                                    child: new Text(
                                      "FECHAR",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: "Roboto"),
                                    )),
                              ]),
                        ]),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            "Lista dos dados:",
                            style: new TextStyle(
                                fontSize: 14.0, fontFamily: "Roboto"),
                          )
                        ]),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            mensagemDados,
                            style: new TextStyle(
                                fontSize: 14.0, fontFamily: "Roboto"),
                          )
                        ]),
                  ]),
            )),
      ),
    );
  }

  /**
   * Atualizar registros em tela
   */
  void atualizarRegistros() async {
    final qtde = await dbHelper.getQtdeRegistros();
    setState(() {
      mensagemRegistros = "Registros: ${qtde.toString()}";
    });
  }

  /**
   * Evento do botão incluir
   */
  void incluirClick() async {
    if (chaveFormulario.currentState.validate()) {
      //Instancia o objeto Cliente e preenche os atributos do objeto com os dados da interface
      Cliente cliente = new Cliente(int.parse(clienteIdController.text),
          nomeController.text, cpfController.text);
      //Executa a inclusão
      var resultado = await dbHelper.incluir(cliente);
      if (resultado != 0) {
        Fluttertoast.showToast(
            msg: "Inclusão realizada com sucesso!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
        atualizarRegistros();
      } else {
        Fluttertoast.showToast(
            msg: "Inclusão não realizada!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    }
  }

  /**
   * Evento do botão alterar
   */
  void alterarClick() async {
    //Verifica se o clienteId foi preenchido
    if (clienteIdController.text.isNotEmpty) {
      //Instancia o objeto Cliente e preenche os atributos do objeto com os dados da interface
      Cliente cliente =
      await dbHelper.getClient(int.parse(clienteIdController.text));
      if (cliente != null) {
        // Cliente para alterar
        Cliente cliente = new Cliente(int.parse(clienteIdController.text),
            nomeController.text, cpfController.text);
        final resultadoAlteracao = await dbHelper.alterar(cliente);
        if (resultadoAlteracao != 0) {
          Fluttertoast.showToast(
              msg: "Alteração realizada com sucesso!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
        } else {
          Fluttertoast.showToast(
              msg: "Alteração não realizada!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Cliente não encontrado, digite um clienteId válido!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Digite um clienteId!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
      clienteIdFocus.requestFocus();
    }
  }

  /**
   * Evento do botão excluir
   */
  void excluirClick() async {
    //Verifica se o clienteId foi preenchido
    if (clienteIdController.text.isNotEmpty) {
      //Instancia o objeto Cliente e preenche os atributos do objeto com os dados da interface
      Cliente cliente =
      await dbHelper.getClient(int.parse(clienteIdController.text));
      if (cliente != null) {
        final resultadoExclusao =
        await dbHelper.excluir(int.parse(clienteIdController.text));
        if (resultadoExclusao != 0) {
          Fluttertoast.showToast(
              msg: "Exclusão realizada com sucesso!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
          atualizarRegistros();
        } else {
          Fluttertoast.showToast(
              msg: "Exclusão não realizada!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Cliente não encontrado, digite um clienteId válido!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Digite um clienteId!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
      clienteIdFocus.requestFocus();
    }
  }

  /**
   * Evento do botão consultar
   */
  void consultarClick() async {
    //Verifica se o clienteId foi preenchido
    if (clienteIdController.text.isNotEmpty) {
      //Instancia o objeto Cliente e preenche os atributos do objeto com os dados da interface
      Cliente cliente =
      await dbHelper.getClient(int.parse(clienteIdController.text));
      if (cliente != null) {
        nomeController.text = cliente.getNome;
        cpfController.text = cliente.getCpf;
        Fluttertoast.showToast(
            msg: "Cliente encontrado!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      } else {
        Fluttertoast.showToast(
            msg: "Cliente não encontrado!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Digite um clienteId!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
    clienteIdFocus.requestFocus();
  }

  /**
   * Evento do botão listar
   */
  void listarClick() async {
    final todasLinhas = await dbHelper.listaRegistros();
    //Percorre a lista concatenando as daidas
    String saida = "";
    for (var row in todasLinhas) {
      saida = saida + row.toString() + "\n";
    }
    //Exibe a saida
    setState(() {
      mensagemDados = "${saida}";
    });
  }

  /**
   * Evento do botão esvaziar BD
   */
  void esvaziarBDClick() async {
    await dbHelper.dropDatabase();
    atualizarRegistros();
  }

  /**
   * Evento do botão limpar
   */
  void limparClick() {
    //Limpa as caixas de texto
    clienteIdController.text = '';
    nomeController.text = '';
    cpfController.text = '';
    setState(() {
      chaveFormulario = GlobalKey<FormState>();
      //Limpa a listagem dos dados
      mensagemDados = "";
    });
    atualizarRegistros();
  }

  /**
   * Evento do botão fechar
   */
  void fecharClick() {
    SystemNavigator.pop();
  }
}
