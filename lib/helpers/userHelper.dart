import '../models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class userHelper {
  static final userHelper _userHelper = userHelper._internal();
  factory userHelper() {
    return _userHelper;
  }
  userHelper._internal();
  String nomeTable = "users";
  late Database _db;
  
  get db async {
      
    _db = await inicializarDB();

    return _db;
    
  }

  _onCreate(Database db, int version) async {
    
    String sql = "CREATE TABLE IF NOT EXISTS $nomeTable (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, CPF TEXT, data DATETIME, local TEXT)";

    await db.execute(sql);

  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados =
        join(caminhoBancoDados, 'banco_meus_usuarios.db');

    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> salvarUser(User user) async {
    
    var BancoDados = await db;
    int resultado = await BancoDados.insert(nomeTable, user.toMap());
    return resultado;
  }

  recuperarUser() async{
    
    var bancoDados = await db;

    String sql = "SELECT * FROM $nomeTable ORDER BY id ASC";

    List Users = await bancoDados.rawQuery(sql);
    
    return Users;

  }

  Future<int> AtualizarUser(User user) async {
    var bancoDados = await db;
    return await bancoDados.update(
      nomeTable,
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id]
    );
  }

  Future<int> deletarUser(User user )async{
    var bancoDados = await db;
    return await bancoDados.delete(
      nomeTable,
      where: "id = ?",
      whereArgs: [user.id]
    );
  } 
}
