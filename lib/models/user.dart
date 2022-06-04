class User{

  int? id;
  String? nome;
  String? CPF;
  String? data;
  String? local;

  User({this.id,required this.nome, required this.CPF, this.data, this.local});

  User.fromMap(Map map){

    this.id = map["id"];
    this.nome = map["nome"];
    this.CPF = map["CPF"];
    this.data = map["data"];
    this.local = map["local"];

  }


  Map toMap(){

    Map<String, dynamic> map = {
      "nome": nome,
      "CPF": CPF,
      "data": data,
      "local": local
    };

    if(id != null){
      map["id"] = id;
    }

    return map;

  }
  
}