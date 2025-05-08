import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zona_azul/app/data/repository/login_repository.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class NovaSenhaController extends GetxController {
  final LoginRepository apiClient = LoginRepository();

  final senha = ''.obs;
  final Naoenviado = true.obs;

  final confirmarSenha = ''.obs;
  final senhaVisivel = false.obs;
  final confirmarSenhaVisivel = false.obs;

  void toggleSenhaVisibility() {
    senhaVisivel.value = !senhaVisivel.value;
  }

  void toggleConfirmarSenhaVisibility() {
    confirmarSenhaVisivel.value = !confirmarSenhaVisivel.value;
  }

  bool validarSenhas() {
    var returndsf = senha.value == confirmarSenha.value;
    if (returndsf) {
      return senha.value == confirmarSenha.value;
    } else {
      Get.snackbar(
        'Erro',
        'Senhas não correspondem',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return senha.value == confirmarSenha.value;
    }
  }

  void resetarSenha() async {
    var email = Storagerds.boxEmailUsuario.read('emailResetar');

    await apiClient.emailResetar(email, senha.value);
    Get.snackbar(
      'Sucesso',
      'Senha alterada com sucesso',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    await Get.offAllNamed(Routes.LOGIN_PAGE);
  }
}

class NovaSenhaPage extends StatelessWidget {
  final NovaSenhaController controller = Get.put(NovaSenhaController());

  NovaSenhaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Senha'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            const Text(
              'Redefina sua senha',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            Obx(() => TextField(
                  obscureText: !controller.senhaVisivel.value,
                  onChanged: (value) => controller.senha.value = value,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      onPressed: () => controller.toggleSenhaVisibility(),
                      icon: Icon(controller.senhaVisivel.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Obx(() => TextField(
                  obscureText: !controller.confirmarSenhaVisivel.value,
                  onChanged: (value) => controller.confirmarSenha.value = value,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    suffixIcon: IconButton(
                      onPressed: () =>
                          controller.toggleConfirmarSenhaVisibility(),
                      icon: Icon(controller.confirmarSenhaVisivel.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed:controller.Naoenviado.value? () async {
                if (controller.validarSenhas()) {
                  controller.resetarSenha();
                  // Senhas válidas, faça o que precisa ser feito
                } else {
                  // Senhas não correspondem, mostre uma mensagem de erro
                }
              }: null,
              child: controller.Naoenviado.value? const Text('Salvar'): const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
