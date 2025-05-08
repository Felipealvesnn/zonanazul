import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/models/ListaVeiculosFipe.dart';
import 'package:zona_azul/app/modules/cadastroUsuarioEditar/controllers/cadastro_usuario_editar_controller.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/cadastro_veiculo_view.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';

class VeiculoProvider extends GetConnect {
  CadastroUsuarioEditarController cadastroUsuarioEditarController =
      CadastroUsuarioEditarController();

  Future<List<ListaVeiculosFipe>> getListVeiculoApi() async {
    var url = "https://parallelum.com.br/fipe/api/v1/carros/marcas/59/modelos";
    var response = await get(url);

    if (response.statusCode == 200) {
      // Decodifica o JSON e mapeia para uma lista de ModeloCarro
      final List<dynamic> jsonList = response.body['modelos'];
      final List<ListaVeiculosFipe> modelos =
          jsonList.map((json) => ListaVeiculosFipe.fromJson(json)).toList();
      return modelos;
    } else {
      // Retorna uma lista vazia em caso de erro na requisição
      return [];
    }
  }

  Future<Map<String, dynamic>?> cadastrarVeiculo(
      String placa, String marca, String cpfcnpj, String token) async {
    var url = baseUrl + "/Veiculo/";

    var body = json.encode({
      "placa": placa,
      "marca": marca,
      "cpfcnpj": cpfcnpj,
    });

    final headers = {"Authorization": 'Bearer ' + token};

    var response = await post(url, body,
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 201) {
      return response.body;
    } else if (response.statusCode == 409) {
      Get.snackbar(
        "Veículo não cadastrado ",
        "Placa já consta na base de dados",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: Duration(seconds: 12),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> atualizarVeiculo(
      String placa, String marca, String cpfcnpj, String token) async {
    var url = baseUrl + "/Veiculo/$placa";

    var body = json.encode({
      "placa": placa,
      "marca": marca,
      "cpfcnpj": cpfcnpj,
    });
    print(body);

    final headers = {"Authorization": 'Bearer ' + token};

    var response =
        await put(url, body, contentType: 'application/json', headers: headers);

    if (response.statusCode == 204) {
      Get.snackbar(
        "Sucesso ",
        "Veiculo atualizado com sucesso!",
        colorText: Colors.white,
        backgroundColor: successColor,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
      Future.delayed(Duration(seconds: 3), () {
        //homeController.loadVeiculos();
        //Get.offNamed(Routes.HOME);

        cadastroUsuarioEditarController.loading.value = false;
        Get.offAllNamed(Routes.HOME);
      });

      return response.body;
    } else {
      Get.snackbar(
        "Veículo não atualizado ",
        "Falha ao contactar servidor, tente novamente",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );
      Future.delayed(Duration(seconds: 5), () {
        //homeController.loadVeiculos();
        //Get.offNamed(Routes.HOME);

        cadastroUsuarioEditarController.loading.value = false;
      });
    }
  }

  Future getVeiculos(String cpfcnpj, String token) async {
    final headers = {"Authorization": 'Bearer ' + token};
    var response = await get(baseUrl + "/Veiculo/$cpfcnpj",
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      /*  Get.defaultDialog(actions: [
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.CADASTRO_VEICULO);
          },
          child: Icon(Icons.add),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(10),
            primary: Colors.blue, // <-- Button color
            onPrimary: Colors.white, // <-- Splash color
          ),
        ),
      ], title: "Atenção", content: Text("Cadastre um veículo.")); */
      return null;
    }
  }

  Future buscarVeiculos(String cpfcnpj, String token) async {
    final headers = {"Authorization": 'Bearer ' + token};
    var response = await get(baseUrl + "/Veiculo/$cpfcnpj",
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future excluirVeiculo(
      String placa, String cpfcnpj, String token) async {
    //http://192.168.0.31/ZonaAzul/api/Veiculo/HGH-2121?cpfCnpj=02455929388
    final headers = {"Authorization": 'Bearer ' + token};

    var response = await delete(baseUrl + "/Veiculo/$placa?cpfcnpj=$cpfcnpj",
        contentType: 'application/json', headers: headers);

    // String url = baseUrl + "/CartaoCreditoDebito/$numero";

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      Get.snackbar(
        "Não foi possivel excluir veiculo ",
        "${response.statusCode.toString()}",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );

      return response.body;
    } else {
      Get.snackbar(
        "Não foi possivel excluir veiculo ",
        "${response.statusCode.toString()}",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );

      response.body;
    }
  }
}
