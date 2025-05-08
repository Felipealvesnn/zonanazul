import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:retry/retry.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class LoginProvider extends GetConnect {
  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<Map<String, dynamic>> login(String username, String password) async {
    timeout = const Duration(minutes: 10);
    final response = await retry(
      () async {
        final response = await post(
            "$baseUrl/Login/", {"email": username, "senha": password});

        if (response.statusCode == 200) {
          return response.body;
        } else {
          return TimeoutException;
        }
      },
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (response is Map<String, dynamic>) {
      return response;
    } else {
      // Get.defaultDialog(
      //   title: "Erro",
      //   content: const Text("Login/Senha não confere."),
      // );
      return <String, dynamic>{};
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<Map<String, dynamic>?> enviarEmail(
      String email, String codigo) async {
    var token = Storagerds.boxToken.read('token');
    final headers = {"Authorization": 'Bearer $token'};
    timeout = const Duration(minutes: 1);
    late Response<dynamic> response;
    // esse metodo retry tenta 8 vezes
    response = await retry(
      () async {
        var response = await post(
            '$baseUrl/emailResetar?email=$email&codigo=$codigo',
            {"email": email, "codigo": codigo},
            headers: headers);

        if (response.statusCode != 200) {
          throw Exception("Erro ao enviar e-mail: ${response.statusCode}");
        }

        return response;
      },
      retryIf: (e) =>
          e is SocketException ||
          e is TimeoutException ||
          response.statusCode != 200,
      // maxAttempts: 8,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(
          "Erro ao obter usuário após várias tentativas: ${response.statusCode}");
      return null;
    }
  }
   

     Future<Map<String, dynamic>?> emailResetar(
      String email, String codigo) async {
    var token = Storagerds.boxToken.read('token');
    final headers = {"Authorization": 'Bearer $token'};
    timeout = const Duration(minutes: 1);
    late Response<dynamic> response;
    // esse metodo retry tenta 8 vezes
    response = await retry(
      () async {
        var response = await post(
            '$baseUrl/emailResetar?email=$email&codigo=$codigo&enviarEmail=false',
            {"email": email, "codigo": codigo},
            headers: headers);

        if (response.statusCode != 200) {
          throw Exception("Erro ao enviar e-mail: ${response.statusCode}");
        }

        return response;
      },
      retryIf: (e) =>
          e is SocketException ||
          e is TimeoutException ||
          response.statusCode != 200,
      // maxAttempts: 8,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(
          "Erro ao obter usuário após várias tentativas: ${response.statusCode}");
      return null;
    }
  }

 
  Future<Map<String, dynamic>?> getUsuario(String token, String cpf) async {
    final headers = {"Authorization": 'Bearer $token'};

    late Response<dynamic> response;
    // esse metodo retry tenta 8 vezes
    response = await retry(
      () async {
        var response = await get("$baseUrl/Usuario/$cpf", headers: headers);

        if (response.statusCode != 200) {
          throw Exception("Erro ao obter usuário: ${response.statusCode}");
        }

        return response;
      },
      retryIf: (e) =>
          e is SocketException ||
          e is TimeoutException ||
          response.statusCode != 200,
      // maxAttempts: 8,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(
          "Erro ao obter usuário após várias tentativas: ${response.statusCode}");
      return null;
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future getConta(String cpf, String token) async {
    final headers = {"Authorization": 'Bearer $token'};
    var response = await get("$baseUrl/Conta/$cpf",
        contentType: 'application/json', headers: headers);
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var convertDataToJson = response.body[0]['saldo'].toString();

      Storagerds.boxSaldo.write('saldo', response.body[0]['saldo']);
      homeController.saldoCad.value = response.body[0]['saldo'].toString();

      return response.body;
    } else {
      return response.body;
    }
  }

  // ignore: non_constant_identifier_names
  Future<Map<String, dynamic>?> Cadastrar(String nome, String cpfcnpj,
      String email, String senha, String celular) async {
    var url = "$baseUrl/Usuario/";
    var body = json.encode({
      "nome": nome,
      "cpfcnpj": cpfcnpj,
      "email": email,
      "senha": senha,
      "celular": celular,
      "tipoUsuarioID": "5"
    });

    var response = await post(url, body);

    if (response.statusCode == 201) {
      return response.body;
    } else {
      Get.snackbar("Erro", response.body.toString(),
          colorText: Colors.white,
          backgroundColor: errorColor,
          duration: const Duration(seconds: 10),
          snackPosition: SnackPosition.TOP);
    }
    return null;
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///
  Future<Map<String, dynamic>?> updateUsuario(String nome, String cpfcnpj,
      String celular, String email, String senha, String token) async {
    final boxcpf = GetStorage('cpfCnpj');
    String cpfAntigo = boxcpf.read('cpfCnpj');
    var url = "$baseUrl/Usuario/$cpfAntigo";

    var body = json.encode({
      "nome": nome,
      "cpfcnpj": cpfcnpj,
      "email": email,
      "senha": senha,
      "celular": celular,
      "tipoUsuarioID": "5"
    });

    final headers = {"Authorization": 'Bearer $token'};

    var response =
        await put(url, body, contentType: 'application/json', headers: headers);

    if (response.statusCode == 204) {
      Get.snackbar(
        "Sucesso ",
        "Dados atualizados com sucesso!",
        colorText: Colors.white,
        backgroundColor: successColor,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

      Future.delayed(const Duration(seconds: 3), () {
        //homeController.loadVeiculos();
        //Get.offNamed(Routes.HOME);

        Get.offAllNamed(Routes.HOME);
      });

      return response.body;
    } else {
      Get.snackbar(
        "Dados não atualizados",
        "Falha ao contactar servidor, tente novamente",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );
      Future.delayed(const Duration(seconds: 5), () {});
      return response.body;
    }
  }

  testaConexao() {
    // ignore: unused_local_variable
    var response = get("$baseUrl/Login/x1");
  }
}
