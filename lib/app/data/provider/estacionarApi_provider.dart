import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/models/Setor.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class EstacioProvider extends GetConnect {
  Future estacionarProvider(
      String placa,
      String cpfcnpj,
      double? latitude,
      double? longitude,
      String local,
      String regraestacionamentoid,
      int qtdCADsolicitado,
      String token) async {
    var url = "$baseUrl/Estacionar/";

    var body = json.encode({
      "placa": placa,
      "cpfcnpj": cpfcnpj,
      "latitude": latitude,
      "longitude": longitude,
      "local": local,
      "regraestacionamentoid": regraestacionamentoid,
      "qtdCADsolicitado": qtdCADsolicitado
    });
    print(body);

    final headers = {"Authorization": 'Bearer $token'};

    var response = await post(url, body,
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 409) {
      Get.snackbar(
        "Veículo não cadastrado ",
        "Placa já consta na base de dados",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 12),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      return response.body;
    }
  }

  //
  //
  //
  //
  //

  Future renovarEstacionarProvider(
      String chaveAutenticacao, String cpfcnpj, String token) async {
    var url = "$baseUrl/RenovarEstacionamento/";

    var body = json.encode({
      "possuiSaldo": true,
      "placa": "string",
      "mensagem": "string",
      "saldo": 0,
      "qtdCADsolicitado": 0,
      "tempoEstacionamento": 0,
      "chaveAutenticacao": chaveAutenticacao,
      "cpfcnpj": "string",
      "dataHoraInicio": "string",
      "dataHoraFim": "string",
      "local": "string",
      "regraEstacionamentoID": "string",
      "descricaoregraEstacionamento": "string",
      "latitude": 0,
      "longitude": 0
    });

    final headers = {"Authorization": 'Bearer $token'};

    var response = await post(url, body,
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 200) {
      //homeController.loadUltimoHistoricoEstacionamentoHomeController();
      return response.body;
    } else if (response.statusCode == 500) {
      Get.snackbar(
        "Falha ao renovar estacionamento",
        "Aguarde alguns instantes e tente novamente",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 12),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      return null;
    }
  }

  Future<Setor?> GetSetor(String token,
      {required String longitude, required String latitude}) async {
    httpClient.maxAuthRetries = 3;
    var url = "$baseUrl/GetSetor/?latitude=$latitude&Longitude=$longitude";

    final headers = {"Authorization": 'Bearer $token'};

    var response = await get(url, headers: headers);

    if (response.statusCode == 200) {
      Setor setor = Setor.fromJson(response.body);
      return setor;
    } else {
      return null;
    }
  }

  Future cancelarEstacioname() async {
    timeout = const Duration(minutes: 1);
    var token = await Storagerds.boxToken.read('token');
    var cpf = await Storagerds.boxcpf.read('cpfCnpj');

     var url = "$baseUrl/CancelarEstacionamento?cpf=$cpf";
    final headers = {"Authorization": 'Bearer ' + token};

    var body = json.encode({
      "cpf": cpf,
    });

    var response = await post(url, body,
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }


}
