import 'package:zona_azul/app/data/models/usuario_model.dart';

class HistoricoEstacionamento {
  String? historicoID;
  String? placa;
  double? valor;
  int? qtdCAD;
  int? tempoEstacionamento;
  String? regraEstacionamento;
  String? chaveAutenticacao;
  String? cpfcnpj;
  String? tipoPagamentoID;
  DateTime? dataHoraInicio;
  DateTime? dataHoraFim;
  DateTime? horarioCancelado;

  String? local;
  String? regraEstacionamentoID;
  double? latitude;
  double? longitude;
  String? usuarioID;
  int? tipoMovimentoID;
  DateTime? dataEvento;
  String? strInicio;
  String? strfim;
  String? status;
  String? url;
  String? setor;
  int? cidadeId;
  dynamic? avisoIrregularidade;
  dynamic? cidades;
  dynamic? tipoMovimento;
  Usuario? usuario;

  HistoricoEstacionamento({
    this.historicoID,
    this.placa,
    this.valor,
    this.qtdCAD,
    this.tempoEstacionamento,
    this.regraEstacionamento,
    this.chaveAutenticacao,
    this.cpfcnpj,
    this.tipoPagamentoID,
    this.dataHoraInicio,
    this.dataHoraFim,
    this.horarioCancelado,
    this.local,
    this.regraEstacionamentoID,
    this.latitude,
    this.longitude,
    this.usuarioID,
    this.tipoMovimentoID,
    this.dataEvento,
    this.strInicio,
    this.strfim,
    this.status,
    this.url,
    this.setor,
    this.cidadeId,
    this.avisoIrregularidade,
    this.cidades,
    this.tipoMovimento,
    this.usuario,
  });

  factory HistoricoEstacionamento.fromJson(Map<String, dynamic> json) =>
      HistoricoEstacionamento(
        historicoID: json['historicoID'],
        placa: json['placa'],
        valor: json['valor'],
        qtdCAD: json['qtdCAD'],
        tempoEstacionamento: json['tempoEstacionamento'],
        regraEstacionamento: json['regraEstacionamento'],
        chaveAutenticacao: json['chaveAutenticacao'],
        cpfcnpj: json['cpfcnpj'],
        tipoPagamentoID: json['tipoPagamentoID'],
        dataHoraInicio: json['dataHoraInicio'] != null
            ? DateTime.parse(json['dataHoraInicio'])
            : null,
        dataHoraFim: json['dataHoraFim'] != null
            ? DateTime.parse(json['dataHoraFim'])
            : null,
            horarioCancelado: json['horarioCancelado'] != null
            ? DateTime.parse(json['horarioCancelado'])
            : null,
        local: json['local'],
        regraEstacionamentoID: json['regraEstacionamentoID'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        usuarioID: json['usuarioID'],
        tipoMovimentoID: json['tipoMovimentoID'],
        dataEvento: json['dataEvento'] != null
            ? DateTime.parse(json['dataEvento'])
            : null,
        strInicio: json['strInicio'],
        strfim: json['strfim'],
        status: json['status'],
        url: json['url'],
        setor: json['setor'],
        cidadeId: json['cidadeId'],
        // avisoIrregularidade: json['avisoIrregularidade'] != null
        //     ? List<AvisoIrregularidade>.from(json['avisoIrregularidade']
        //         .map((x) => AvisoIrregularidade.fromJson(x)))
        //     : null,
        // cidades: json['cidades'] != null
        //     ? Cidades.fromJson(json['cidades'])
        //     : null,
        // tipoMovimento: json['tipoMovimento'] != null
        //     ? TipoMovimento.fromJson(json['tipoMovimento'])
        //     : null,
        usuario: json['usuario'] != null
            ? Usuario.fromJson(json['usuario'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'historicoID': historicoID,
        'placa': placa,
        'valor': valor,
        'qtdCAD': qtdCAD,
        'tempoEstacionamento': tempoEstacionamento,
        'regraEstacionamento': regraEstacionamento,
        'chaveAutenticacao': chaveAutenticacao,
        'cpfcnpj': cpfcnpj,
        'tipoPagamentoID': tipoPagamentoID,
        'dataHoraInicio': dataHoraInicio?.toIso8601String(),
        'dataHoraFim': dataHoraFim?.toIso8601String(),
        'local': local,
        'regraEstacionamentoID': regraEstacionamentoID,
        'latitude': latitude,
        'longitude': longitude,
        'usuarioID': usuarioID,
        'tipoMovimentoID': tipoMovimentoID,
        'dataEvento': dataEvento?.toIso8601String(),
        'strInicio': strInicio,
        'strfim': strfim,
        'status': status,
        'url': url,
        'setor': setor,
        'cidadeId': cidadeId,
        'avisoIrregularidade': avisoIrregularidade != null
            ? List<dynamic>.from(avisoIrregularidade!.map((x) => x.toJson()))
            : null,
        'cidades': cidades?.toJson(),
        'tipoMovimento': tipoMovimento?.toJson(),
        'usuario': usuario?.toJson(),
      };
}

