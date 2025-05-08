// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:http/http.dart' as http;

/* String? nomeTitular;
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
  */
class CartaoCreditoDebitoProvider extends GetConnect {
  final boxRetornoDaApiRequisicao = GetStorage('boxRetornoDaApiRequisicao');

  Future<Map<String, dynamic>?> cadastrarCartaoCreditoDebito(
      String nomeTitular,
      String numero,
      String anoExpiracao,
      String mesExpiracao,
      int codSeguranca,
      String tipoCartao,
      String cpfcnpj,
      String token) async {
    var url = "$baseUrl/CartaoCreditoDebito/";

    var body = json.encode({
      "nomeTitular": nomeTitular,
      "numero": numero,
      "anoExpiracao": anoExpiracao,
      "mesExpiracao": mesExpiracao,
      "codSeguranca": codSeguranca,
      "cpfcnpj": cpfcnpj,
      "tipoCartao": tipoCartao
    });
    print(body);

    final headers = {"Authorization": 'Bearer $token'};

    var response = await post(url, body,
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 201) {
      return response.body;
    } else {
      Get.snackbar(
        "Erro ",
        response.body.values.first,
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 12),
        snackPosition: SnackPosition.TOP,
      );
    }
    return null;
  }

  Future getCartaoCredidoDebito(String cpfcnpj, String token) async {
    final headers = {"Authorization": 'Bearer $token'};
    timeout = const Duration(minutes: 1);

      var response = await get("$baseUrl/CartaoCreditoDebito/$cpfcnpj",
          contentType: 'application/json', headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 404) {
        boxRetornoDaApiRequisicao.write('boxRetornoDaApiRequisicao',
            "Nenhum cartão cadastrado foi encontrado");

        return null;
      }
  
  }

  Future deleteCartaoCreditoDebito(
      String numero, String cpfcnpj, String token) async {
    final headers = {"Authorization": 'Bearer $token'};

    var response = await delete(
        "$baseUrl/CartaoCreditoDebito/$numero?cpfcnpj=$cpfcnpj",
        contentType: 'application/json',
        headers: headers);

    // String url = baseUrl + "/CartaoCreditoDebito/$numero";

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      boxRetornoDaApiRequisicao.write('boxRetornoDaApiRequisicao',
          "Nenhum cartão cadastrado foi encontrado");
      Get.snackbar(
        "Erro ",
        "Não foi possivel excluir cartao",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );

      return response.body;
    }
  }
}
