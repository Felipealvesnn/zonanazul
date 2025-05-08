import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/repository/login_repository.dart';
import 'package:zona_azul/app/modules/login_page/controllers/login_page_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';

class CadastroUsuarioEditarController extends GetxController {
  final boxToken = GetStorage('token');
  final LoginRepository repository = LoginRepository();
  final box = GetStorage('zonaAzul');
  final boxvalorAlertaSelecionado = GetStorage('boxvalorAlertaSelecionado');

  RxBool aceiteTermos = false.obs;
  RxBool showPassword = false.obs;
  RxBool loading = false.obs;
  RxBool cadastroSucesso = false.obs;
  var auth;

  late String emailTextController;
  late String nomeTextController;
  late String cpfCnpjTextController;
  late String celularTextController;
  late String passwordTextController;
  final TextEditingController nameTextController = TextEditingController();

  String verifyAuth() {
    auth = box.read('usuario');
    if (auth != null) {
      return Routes.HOME;
    } else {
      return Routes.LOGIN_PAGE;
    }
  }

//no projeto inicial este codigo era todo centralizado no Login_controller, porem neste novo formato cada modulo tem seu controller

  atualizarUsuario(String nome, String cpfcnpj, String celular, String email,
      String senha, String token) async {
    await repository.atualizarUser(nome, cpfcnpj, celular, email, senha, token);
    loading.value = false;
    /*  Future.delayed(Duration(seconds: 4), () {
      loginPageController.loginAtualizar(email, senha);
    }); */
  }

  void testarConexao() {
    loading.value = true;
    repository.testaConexao();
  }
}
