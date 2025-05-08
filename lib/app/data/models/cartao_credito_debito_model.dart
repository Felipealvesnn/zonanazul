class CartaoCreditoDebito {
  String? nomeTitular;
  String? numero;
  String? validade;
  int? codSeguranca;
  String? cpfcnpj;
  String? bandeira;
  String? tipoCartao;
  String? anoExpiracao;
  String? mesExpiracao;
  String? ultimosDigitos;
  dynamic cardId;
  dynamic numberToken;
  dynamic usuario;

  CartaoCreditoDebito(
      {this.nomeTitular,
      this.numero,
      this.validade,
      this.codSeguranca,
      this.cpfcnpj,
      this.bandeira,
      this.tipoCartao,
      this.anoExpiracao,
      this.mesExpiracao,
      this.ultimosDigitos,
      this.cardId,
      this.numberToken,
      this.usuario});

  CartaoCreditoDebito.fromJson(Map<String, dynamic> json) {
    nomeTitular = json['nomeTitular'];
    numero = json['numero'];
    validade = json['validade'];
    codSeguranca = json['codSeguranca'];
    cpfcnpj = json['cpfcnpj'];
    bandeira = json['bandeira'];
    tipoCartao = json['tipoCartao'];
    anoExpiracao = json['anoExpiracao'];
    mesExpiracao = json['mesExpiracao'];
    ultimosDigitos = json['ultimosDigitos'];
    cardId = json['card_Id'];
    numberToken = json['number_token'];
    usuario = json['Usuario'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nomeTitular'] = nomeTitular;
    data['numero'] = numero;
    data['validade'] = validade;
    data['codSeguranca'] = codSeguranca;
    data['cpfcnpj'] = cpfcnpj;
    data['bandeira'] = bandeira;
    data['tipoCartao'] = tipoCartao;
    data['anoExpiracao'] = anoExpiracao;
    data['mesExpiracao'] = mesExpiracao;
    data['ultimosDigitos'] = ultimosDigitos;
    data['card_Id'] = cardId;
    data['number_token'] = numberToken;
    data['Usuario'] = usuario;
    return data;
  }
}
