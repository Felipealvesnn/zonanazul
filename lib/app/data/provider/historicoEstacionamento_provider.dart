import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:retry/retry.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/modules/home/views/widgets/ListCarButton.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:zona_azul/app/utils/funcoesutilsd.dart';

class HistoricoEstacionamentoProvider extends GetConnect {
  Future getHistoricoEcomprasLog(String cpfcnpj, String token,
      {String? dataInicial, String? dataFinal}) async {
        
    timeout = const Duration(minutes: 1);

    final headers = {"Authorization": 'Bearer $token'};
    String url = "$baseUrl/ExtratoUsuario/$cpfcnpj";

    // Adiciona as datas à URL se estiverem presentes
    if (dataInicial != null && dataFinal != null) {
      url += '?dataInicio=$dataInicial&dataFim=$dataFinal';
    }
    final response = await retry(
      () async {
        final response = await get(
          url,
          contentType: 'application/json',
          headers: headers,
        );

        if (response.statusCode == 200) {
          return response.body;
        } else {
          return TimeoutException;
        }
      },
      retryIf: (e) {
        FuncoesParaAjudar.logger.w("Erro ao obter último estacionamento: $e");
        return e is SocketException || e is TimeoutException;
      },
    );

    if (response != null && response != TimeoutException) {
      return response;
    } else {
      return null;
    }
  }

  Future getHistoricoEstacionamento(String cpfcnpj, String token) async {
    try {
      httpClient.maxAuthRetries = 3;
      final headers = {"Authorization": 'Bearer $token'};
      var response = await get("$baseUrl/HistoricoEstacionamento/$cpfcnpj",
          contentType: 'application/json', headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 404) {
        FuncoesParaAjudar.logger.d("erro ao listar historico");

        return null;
      }
    } catch (e) {
      FuncoesParaAjudar.logger.w("error: ${e.toString()}");
    }
  }

  Future getUltimoEstacionamento(String cpfcnpj, String token,
      {String? dataInicial, String? dataFinal}) async {
    final headers = {"Authorization": 'Bearer $token'};
    String url = "$baseUrl/HistoricoEstacionamento/$cpfcnpj?ultimoHistorico=s";

    // Adiciona as datas à URL se estiverem presentes
    if (dataInicial != null && dataFinal != null) {
      url += '&dataInicio=$dataInicial&dataFim=$dataFinal';
    } else {
      // Calcular a data 3 dias atrás
      DateTime tresDiasAtras = DateTime.now().subtract(const Duration(days: 3));
      // Formatar a data no formato desejado (yyyy-MM-dd)
      String dataFormatada = DateFormat('yyyy-MM-dd').format(tresDiasAtras);
      // Usar a data formatada como data inicial
      url += '&dataInicio=$dataFormatada';
    }
    timeout = const Duration(minutes: 1);
    final response = await retry(
      () async {
        final response = await get(
          url,
          contentType: 'application/json',
          headers: headers,
        );

        if (response.statusCode == 200) {
          return response.body;
        } else {
          return TimeoutException;
        }
      },
      retryIf: (e) {
        FuncoesParaAjudar.logger.w("Erro ao obter último estacionamento: $e");
        return e is SocketException || e is TimeoutException;
      },
    );

    if (response != null && response != TimeoutException) {
      return response;
    } else {
      return null;
    }
  }
}
