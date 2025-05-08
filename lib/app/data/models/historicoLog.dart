import 'dart:convert';

import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';

class HistoricoLog {
  HistoricoEstacionamento? estacionamento;
  LogPagamento? pagamento;
  String? tipo; // "Estacionamento" ou "Compra"
  DateTime? data;

  HistoricoLog({this.estacionamento, this.pagamento, this.tipo, this.data});

  HistoricoLog.fromJson(Map<String, dynamic> json) {
    estacionamento = (json['Estacionamento'] ?? json['estacionamento']) != null
        ? HistoricoEstacionamento.fromJson(((json['Estacionamento']?? json['estacionamento'] )))
        : null;
    pagamento = (json['Pagamento']??  json['pagamento']) != null
        ? LogPagamento.fromJson((json['Pagamento']??  json['pagamento']))
        : null;
    tipo = json['Tipo']?? json['tipo'];
    data = DateTime.parse((json['Data']?? json['data']));
  }

  Map<String, dynamic> toJson() => {
        'estacionamento': estacionamento?.toJson(),
        'pagamento': pagamento?.toJson(),
        'tipo': tipo,
        'data': data?.toIso8601String(),
      };
}

class LogPagamento {
  String? logPagamentoID;
  double? valorpago;
  String? cpfcnpj;
  DateTime? dataPagamento;
  int? qtdcad;
  String? payment_id;
  String? status_code;
  String? message;
  int? pondoDeVendaID;

  Usuario? usuario;

  LogPagamento.fromJson(Map<String, dynamic> json) {
    logPagamentoID = json['logPagamentoID'];
    valorpago = json['valorpago'];
    cpfcnpj = json['cpfcnpj'];
    dataPagamento = DateTime.parse(json['dataPagamento']);
    qtdcad = json['qtdcad'];
    payment_id = json['payment_id'];
    status_code = json['status_code'];
    message = json['message'];
    pondoDeVendaID = json['pondoDeVendaID'];
    usuario =
        json['usuario'] != null ? Usuario.fromJson(json['usuario']) : null;
  }

  Map<String, dynamic> toJson() => {
        'logPagamentoID': logPagamentoID,
        'valorpago': valorpago,
        'cpfcnpj': cpfcnpj,
        'dataPagamento': dataPagamento?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'qtdcad': qtdcad,
        'payment_id': payment_id,
        'status_code': status_code,
        'message': message,
        'pondoDeVendaID': pondoDeVendaID,
        'usuario': usuario?.toJson(),
      };

  LogPagamento({
    this.logPagamentoID,
    this.valorpago,
    this.cpfcnpj,
    this.dataPagamento,
    this.qtdcad,
    this.payment_id,
    this.status_code,
    this.message,
    this.pondoDeVendaID,
    this.usuario,
  });
}
