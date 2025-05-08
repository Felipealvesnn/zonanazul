import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';

class Veiculo {
  String? placa;
  String? marca;
  String? cpfcnpj;
  List<HistoricoEstacionamento>? historicoEstacionamento;
  dynamic usuario;

  Veiculo(
      {this.placa,
      this.marca,
      this.cpfcnpj,
      this.historicoEstacionamento,
      this.usuario});

  Veiculo.fromJson(Map<String, dynamic> json) {
    placa = json['placa'];
    marca = json['marca'];
    cpfcnpj = json['cpfcnpj'];
    if (json['HistoricoEstacionamento'] != null) {
      historicoEstacionamento = <HistoricoEstacionamento>[];
      json['HistoricoEstacionamento'].forEach((v) {
        historicoEstacionamento!.add(HistoricoEstacionamento.fromJson(v));
      });
    }
    usuario = json['Usuario'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['placa'] = placa;
    data['marca'] = marca;
    data['cpfcnpj'] = cpfcnpj;
    if (historicoEstacionamento != null) {
      data['HistoricoEstacionamento'] =
          historicoEstacionamento!.map((v) => v.toJson()).toList();
    }
    data['Usuario'] = usuario;
    return data;
  }
}
