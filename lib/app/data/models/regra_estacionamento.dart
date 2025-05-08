import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';

class RegraEstacionamento {
  String? regraEstacionamentoID;
  String? descricao;
  double? tempo;
  int? tipoCad;
  List<HistoricoEstacionamento>? historicoEstacionamento;

  RegraEstacionamento(
      {this.regraEstacionamentoID,
      this.descricao,
      this.tempo,
      this.tipoCad,
      this.historicoEstacionamento});

  RegraEstacionamento.fromJson(Map<String, dynamic> json) {
    regraEstacionamentoID = json['regraEstacionamentoID'];
    descricao = json['descricao'];
    tempo = json['tempo'];
    tipoCad = json['tipoCad'];
    if (json['HistoricoEstacionamento'] != null) {
      historicoEstacionamento = <HistoricoEstacionamento>[];
      json['HistoricoEstacionamento'].forEach((v) {
        historicoEstacionamento!.add(HistoricoEstacionamento.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['regraEstacionamentoID'] = regraEstacionamentoID;
    data['descricao'] = descricao;
    data['tempo'] = tempo;
    data['tipoCad'] = tipoCad;
    if (historicoEstacionamento != null) {
      data['HistoricoEstacionamento'] =
          historicoEstacionamento?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
