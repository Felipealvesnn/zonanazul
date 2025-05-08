
class Pagamento {
  int? qtdCAD;
  String? cpf;
  String? numeroCartao;
  String? tipoPagamento;
  int? valor;

  Pagamento(
      {this.qtdCAD,
      this.cpf,
      this.numeroCartao,
      this.tipoPagamento,
      this.valor});

  Pagamento.fromJson(Map<String, dynamic> json) {
    qtdCAD = json['qtdCAD'];
    cpf = json['cpf'];
    numeroCartao = json['numeroCartao'];
    tipoPagamento = json['tipoPagamento'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qtdCAD'] = qtdCAD;
    data['cpf'] = cpf;
    data['numeroCartao'] = numeroCartao;
    data['tipoPagamento'] = tipoPagamento;
    data['valor'] = valor;
    return data;
  }
}
