class Cad {
  int? cadID;
  String? descricao;
  int? tempo;
  double? valor;
  int? unidade;

  Cad({this.cadID, this.descricao, this.tempo, this.valor, this.unidade});

  Cad.fromJson(Map<String, dynamic> json) {
    cadID = json['cadID'];
    descricao = json['descricao'];
    tempo = json['tempo'];
    valor = json['valor'];
    unidade = json['unidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cadID'] = cadID;
    data['descricao'] = descricao;
    data['tempo'] = tempo;
    data['valor'] = valor;
    data['unidade'] = unidade;
    return data;
  }
}
