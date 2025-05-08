import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/routes/app_pages.dart';

class PagamentoProvider extends GetConnect {


  Future<Map<String, dynamic>?> postPagamentoProvider(
      /* int? qtdCAD;
  String? cpf;
  String? numeroCartao;
  String? tipoPagamento;
  Double? valor;*/
      int qtdCAD,
      String cpf,
      String numeroCartao,
      String tipoPagamento,
      double valor,
      String token) async {
    var url = baseUrl + "/Pagamento/";

    var body = json.encode({
      "qtdCAD": qtdCAD,
      "cpf": cpf,
      "numeroCartao": numeroCartao,
      "tipoPagamento": tipoPagamento,
      "valor": valor,
    });

    final headers = {"Authorization": 'Bearer ' + token};

    var response = await post(url, body,
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 201) {
      return response.body;
    } else if (response.statusCode == 500) {
      Get.snackbar(
        "Erro ",
        "Não foi possivel registrar o pagamento",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: Duration(seconds: 12),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      return null;
    }
  }


}
