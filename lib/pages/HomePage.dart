import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../helpers/userHelper.dart';

import '../models/user.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController localController = TextEditingController();

  var _db = userHelper();
  List<User> _User = [];
  String botao = 'salvar';

  _ExbirTelaCadastro({User? user}) {
    String TextoSalvarAtualizar = "";
    if (user == null) {
      tituloController.text = "";
      descricaoController.text = "";
      TextoSalvarAtualizar = "salvar";
    } else {
      tituloController.text = user.nome.toString();
      descricaoController.text = user.CPF.toString();
      localController.text = user.local.toString();
      TextoSalvarAtualizar = "atualizar";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$TextoSalvarAtualizar usuário'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "nome",
                hintText: "Digite o nome...",
                focusColor: Colors.lightGreen,
                labelStyle: TextStyle(color: Colors.lightGreen),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2,
                )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2,
                )),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: descricaoController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "CPF",
                hintText: "Digite o CPF...",
                labelStyle: TextStyle(color: Colors.lightGreen),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2,
                )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2,
                )),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: localController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "local",
                hintText: "Digite o local...",
                labelStyle: TextStyle(color: Colors.lightGreen),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2,
                )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2,
                )),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.lightGreen)),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.lightGreen)),
            onPressed: () {
              _salvarAtualizarUser(UserSelecionado: user);

              Navigator.pop(context);
            },
            child: Text(TextoSalvarAtualizar),
          ),
        ],
      ),
    );
  }

  _recuperarUsers() async {
    List UsersRecuperados = await _db.recuperarUser();
    List<User>? ListaTemporaria = [];
    for (var i in UsersRecuperados) {
      User user = User.fromMap(i);
      ListaTemporaria.add(user);
    }

    setState(() {
      _User = ListaTemporaria!;
    });

    ListaTemporaria = null;

    print("Lista de anotações ${UsersRecuperados.toString()}");
  }

  _salvarAtualizarUser({User? UserSelecionado}) async {
    String Titulo = tituloController.text;
    String Descricao = descricaoController.text;
    String local = localController.text;

    if (UserSelecionado == null) {
      User user = User(
          nome: Titulo,
          CPF: Descricao,
          data: DateFormat('d/M/y').format(DateTime.now()),
          local: local);
      int resultado = await _db.salvarUser(user);
      print(resultado.toString());
    } else {
      UserSelecionado.nome = Titulo;
      UserSelecionado.CPF = Descricao;
      UserSelecionado.local = local;
      int resultado = await _db.AtualizarUser(UserSelecionado);
    }

    tituloController.clear();
    descricaoController.clear();
    localController.clear();

    _recuperarUsers();
  }

  _deletarUser(User user) async {
    await _db.deletarUser(user);
    _recuperarUsers();
  }

  @override
  void initState() {
    super.initState();

    _recuperarUsers();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Gerenciamento de vendas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Colors.lightGreen,
              child: ListView.builder(
                itemCount: _User.length,
                itemBuilder: (context, index) {
                  final user = _User[index];

                  return Card(
                    child: ListTile(
                      title: Text("${user.id}.${user.nome}"),
                      subtitle: Text(
                          "${user.CPF} - ${user.data} - ${user.local}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _ExbirTelaCadastro(user: user);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(Icons.edit),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Quer deletar este usuário?'),
                                      actions: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                                          ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Cancelar')),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                                          ),
                                            onPressed: () {
                                              _deletarUser(user);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Confirmar'))
                                      ],
                                    );
                                  });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(Icons.delete),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
            ) 
          )
            ) 
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          _ExbirTelaCadastro();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
