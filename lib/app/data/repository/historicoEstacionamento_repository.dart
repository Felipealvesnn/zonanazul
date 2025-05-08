import 'dart:async';

import 'package:zona_azul/app/data/models/cad.dart';
import 'package:zona_azul/app/data/models/historicoLog.dart';
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/data/provider/cad_provider.dart';
import 'package:zona_azul/app/data/provider/historicoEstacionamento_provider.dart';

class HistoricoEstacionamentoRepository {
  HistoricoEstacionamentoProvider historicoEstacionamentoProvider =
      HistoricoEstacionamentoProvider();

  Future<List<HistoricoLog>> getHistoricoEcomprasLog(
      String cpfcnpj, String token,
      {String? dataInicial, String? dataFinal}) async {
    List<HistoricoLog> listHistoricoLog = <HistoricoLog>[];

    var response = await historicoEstacionamentoProvider
        .getHistoricoEcomprasLog(cpfcnpj, token,
            dataInicial: dataInicial, dataFinal: dataFinal);

    if (response != null) {
      response.forEach((e) {
        listHistoricoLog.add(HistoricoLog.fromJson(e));
      });
    }
    return listHistoricoLog;
  }

  listarHistoricoEstacionamento(String cpfcnpj, String token) async {
    List<HistoricoEstacionamento> listHistorico = <HistoricoEstacionamento>[];

    var response = await historicoEstacionamentoProvider
        .getHistoricoEstacionamento(cpfcnpj, token);

    if (response != null) {
      response.forEach((e) {
        listHistorico.add(HistoricoEstacionamento.fromJson(e));
      });
    }
    return listHistorico;
  }

  Future<List<HistoricoEstacionamento>> listarUltimoHistoricoEstacionamento(
      String cpfcnpj, String token,
      {String? dataInicial, String? dataFinal}) async {
    List<HistoricoEstacionamento> listHistorico = [];

    var response;
    try {
      // Verifica se as datas inicial e final estão presentes
      if (dataInicial != null && dataFinal != null) {
        response =
            await historicoEstacionamentoProvider.getUltimoEstacionamento(
          cpfcnpj,
          token,
          dataInicial: dataInicial,
          dataFinal: dataFinal,
        );
      } else {
        // Se as datas não estiverem presentes, faz a chamada sem elas
        response =
            await historicoEstacionamentoProvider.getUltimoEstacionamento(
          cpfcnpj,
          token,
        );
      }
    } catch (e) {
      print(e);
    }
    if (response != null && response != TimeoutException) {
      response.forEach((e) {
        listHistorico.add(HistoricoEstacionamento.fromJson(e));
      });
    }
    return listHistorico;
  }

 
}
