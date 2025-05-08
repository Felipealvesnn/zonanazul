import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/provider/login_provider.dart';
import 'package:zona_azul/app/modules/comprar_cad/controllers/comprar_cad_controller.dart';
import 'package:zona_azul/app/modules/login_page/controllers/login_page_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

ComprarCadController comprarCadController = Get.find<ComprarCadController>();
LoginPageController loginPageController = LoginPageController();
LoginProvider loginProvider = LoginProvider();
final boxToken = GetStorage('token');

class CadProvider extends GetConnect {
  
  Future getCads(String token) async {
     timeout = const Duration(minutes: 1);
     httpClient.maxAuthRetries = 3;
    final headers = {"Authorization": 'Bearer $token'};
    var response = await get("$baseUrl/Cad/",
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {}
  }

  Future<Map<String, dynamic>> payCads(int qtdCads, String cpf,
      String numeroCartao, String tipoPagamento, double valor) async {
    final token = boxToken.read('token');
    const url = '$baseUrl/Pagamento/';

    final headers = {"Authorization": 'Bearer $token'};

    final data = {
      "qtdCAD": qtdCads,
      "cpf": cpf,
      "numeroCartao": numeroCartao,
      "tipoPagamento": tipoPagamento,
      "valor": valor
    };
    print(data);
   
    final response = await post(
      url,
      data,
      contentType: 'application/json',
      headers: headers,
    );

    if (response.statusCode == 201) {
      comprarCadController.pagando.value = false;
      Get.snackbar(
        "Compra realizada com sucesso",
        "",
        colorText: Colors.white,
        backgroundColor: successColor,
        duration: const Duration(seconds: 2),
      );
      loginProvider.getConta(cpf, token);
      //  Future.delayed(
      //  const Duration(seconds: 2),
      // () =>
      Get.back();
      //  );

      return response.body;
    } else if (response.statusCode == null) {
      comprarCadController.pagando.value = false;
      Get.snackbar(
        "Não foi possível contactar o Servidor",
        "Verifique sua conexão e tente novamente",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
      return response.body;
    } else if (response.statusCode == 400) {
      final json = response.body;
      //final message = json['ModelState']['message'][0];
      //final description = json['ModelState']['description_detail'][0];

      Get.snackbar(
        "Error",
        "Erro ao realizar a compra: ",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );
       Future.delayed(const Duration(seconds: 2), () {
      comprarCadController.pagando.value = false;
      Get.back();
        });

      return response.body;
    } else {
      comprarCadController.pagando.value = false;
      return response.body;
    }
  }
}
