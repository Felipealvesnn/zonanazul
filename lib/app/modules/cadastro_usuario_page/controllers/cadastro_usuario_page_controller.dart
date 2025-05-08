import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/repository/login_repository.dart';
import 'package:zona_azul/app/routes/app_pages.dart';

class CadastroUsuarioPageController extends GetxController {
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
  final LoginRepository repository = LoginRepository();
  void toRegister() {
    Get.offAndToNamed(Routes.CADASTRO_USUARIO_PAGE);
  }

  void cadastrar() async {
    try {
      //if (formKey.currentState!.validate()) {
      loading.value = true;
      await repository
          .cadastrar(
              nomeTextController,
              cpfCnpjTextController,
              emailTextController,
              passwordTextController,
              celularTextController)
          .then((auth) {
        if (auth != null) {
          box.write('usuario', auth);
          var dados = box.read('usuario');

          Get.snackbar(
            "Sucesso ",
            "Cadastro realizado com sucesso!",
            colorText: Colors.white,
            backgroundColor: successColor,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          );

          boxvalorAlertaSelecionado.write('boxvalorAlertaSelecionado', 10);

          cadastroSucesso.value = true;
          Future.delayed(Duration(seconds: 3), () {
            if (cadastroSucesso.value == true) {
              Get.offAllNamed(Routes.LOGIN_PAGE);
              cadastroSucesso.value = false;
              loading.value = false;
            }
          });
        }
        //loading.value = false;
      }).catchError((err) {
        //Get.defaultDialog(title: "Erro", content: Text("Errox: ${err}"));
        loading.value = false;
      });
      // }
    } catch (e) {
      Get.snackbar("Erro", "${e.toString()}",
          colorText: Colors.white, backgroundColor: errorColor);
    }
  }

  void testarConexao() {
    loading.value = true;
    repository.testaConexao();
  }
}
