class Localizacao {

  int idLocalizacao;
  double latitude;
  double longitude;
  String horario;

  Localizacao(this.idLocalizacao, this.latitude, this.longitude, this.horario);

  Localizacao.fromMap(dynamic obj) {
    this.idLocalizacao = obj['idLocalizacao'];
    this.latitude = obj['latitude'];
    this.longitude = obj['longitude'];
    this.horario = obj['horario'];
  }

//  String get latitude => latitude;
//  String get longitude => longitude;
//  String get horario => horario;
//  int get idLocalizacao => idLocalizacao;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["idLocalizacao"] = idLocalizacao;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["horario"] = horario;
    return map;
  }
}