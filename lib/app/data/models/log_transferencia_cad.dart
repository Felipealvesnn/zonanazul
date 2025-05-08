import 'package:zona_azul/app/data/models/conta_model.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';

class LogTransferenciaCad {
  int? logTranferanciaCadID;
  int? qtdCad;
  String? dataEvento;
  String? usuarioIDcreditado;
  int? valor;
  String? usuarioIDliberacao;
  String? contaID;
  List<Conta>? conta;
  List<Usuario>? usuario;

  LogTransferenciaCad(
      {this.logTranferanciaCadID,
      this.qtdCad,
      this.dataEvento,
      this.usuarioIDcreditado,
      this.valor,
      this.usuarioIDliberacao,
      this.contaID,
      this.conta,
      this.usuario});

  LogTransferenciaCad.fromJson(Map<String, dynamic> json) {
    logTranferanciaCadID = json['logTranferanciaCadID'];
    qtdCad = json['qtdCad'];
    dataEvento = json['dataEvento'];
    usuarioIDcreditado = json['usuarioIDcreditado'];
    valor = json['valor'];
    usuarioIDliberacao = json['usuarioIDliberacao'];
    contaID = json['contaID'];
    if (json['Conta'] != null) {
      conta = <Conta>[];
      json['Conta'].forEach((v) {
        conta!.add(Conta.fromJson(v));
      });
    }
    if (json['Usuario'] != null) {
      usuario = <Usuario>[];
      json['Usuario'].forEach((v) {
        usuario!.add(Usuario.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logTranferanciaCadID'] = logTranferanciaCadID;
    data['qtdCad'] = qtdCad;
    data['dataEvento'] = dataEvento;
    data['usuarioIDcreditado'] = usuarioIDcreditado;
    data['valor'] = valor;
    data['usuarioIDliberacao'] = usuarioIDliberacao;
    data['contaID'] = contaID;
    if (conta != null) {
      data['Conta'] = conta!.map((v) => v.toJson()).toList();
    }
    if (usuario != null) {
      data['Usuario'] = usuario!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
