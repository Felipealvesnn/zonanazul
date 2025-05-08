class EstacionarApi {
  bool? possuiSaldo;
  String? placa;
  String? mensagem;
  int? saldo;
  int? qtdCADsolicitado;
  int? tempoEstacionamento;
  String? chaveAutenticacao;
  String? cpfcnpj;
  String? dataHoraInicio;
  String? dataHoraFim;
  String? local;
  String? regraEstacionamentoID;
  String? descricaoregraEstacionamento;
  double? latitude;
  double? longitude;

  EstacionarApi(
      {this.possuiSaldo,
      this.placa,
      this.mensagem,
      this.saldo,
      this.qtdCADsolicitado,
      this.tempoEstacionamento,
      this.chaveAutenticacao,
      this.cpfcnpj,
      this.dataHoraInicio,
      this.dataHoraFim,
      this.local,
      this.regraEstacionamentoID,
      this.descricaoregraEstacionamento,
      this.latitude,
      this.longitude});

  EstacionarApi.fromJson(Map<String, dynamic> json) {
    possuiSaldo = json['possuiSaldo'];
    placa = json['placa'];
    mensagem = json['mensagem'];
    saldo = json['saldo'];
    qtdCADsolicitado = json['qtdCADsolicitado'];
    tempoEstacionamento = json['tempoEstacionamento'];
    chaveAutenticacao = json['chaveAutenticacao'];
    cpfcnpj = json['cpfcnpj'];
    dataHoraInicio = json['dataHoraInicio'];
    dataHoraFim = json['dataHoraFim'];
    local = json['local'];
    regraEstacionamentoID = json['regraEstacionamentoID'];
    descricaoregraEstacionamento = json['descricaoregraEstacionamento'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['possuiSaldo'] = possuiSaldo;
    data['placa'] = placa;
    data['mensagem'] = mensagem;
    data['saldo'] = saldo;
    data['qtdCADsolicitado'] = qtdCADsolicitado;
    data['tempoEstacionamento'] = tempoEstacionamento;
    data['chaveAutenticacao'] = chaveAutenticacao;
    data['cpfcnpj'] = cpfcnpj;
    data['dataHoraInicio'] = dataHoraInicio;
    data['dataHoraFim'] = dataHoraFim;
    data['local'] = local;
    data['regraEstacionamentoID'] = regraEstacionamentoID;
    data['descricaoregraEstacionamento'] = descricaoregraEstacionamento;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
