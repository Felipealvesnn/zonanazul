import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zona_azul/app/data/repository/login_repository.dart';
import 'package:zona_azul/app/modules/esquecerSenha/views/widgets/novaSenha.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class EsquecerSenhaController extends GetxController {
  final LoginRepository apiClient = LoginRepository();
  final RxBool emailNaoEnviado = true.obs;
  final RxBool botaoEmailEnviado = true.obs;

  final RxInt segundosRestantes = 0.obs;

  Timer? _timer;

  void iniciarContagemRegressiva() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (segundosRestantes.value > 0) {
        segundosRestantes.value--;
      } else {
        botaoEmailEnviado.value = true;
        _timer?.cancel();
      }
    });
  }

  String generateRandomDigits() {
    final Random random = Random();
    const String chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String result = '';

    for (int i = 0; i < 6; i++) {
      result += chars[random.nextInt(chars.length)];
    }

    return result;
  }

  Future<void> resetPassword(String email) async {
    try {
      if (segundosRestantes.value == 0) {
        botaoEmailEnviado.value = false;
        final String codigo = generateRandomDigits();
        await Storagerds.boxToken.write('codigo', codigo);
        await Storagerds.boxEmailUsuario.write('emailResetar', email);
        await apiClient.enviarEmail(email, codigo);
        emailNaoEnviado.value = false;

        Get.snackbar(
          'Sucesso',
          'Email enviado com sucesso, verifique sua caixa de entrada.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        segundosRestantes.value = 30;
        iniciarContagemRegressiva();
      } else {
        
        Future.delayed(const Duration(seconds: 1), () {
          botaoEmailEnviado.value = true;
        });

        Get.snackbar(
          'Atenção',
          'Aguarde ${segundosRestantes.value} segundos antes de enviar outro email.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao enviar email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> verificarCodigo(String codigo) async {
    try {
      final String codigoSalvo = Storagerds.boxToken.read('codigo');
      if (codigo.toUpperCase() == codigoSalvo) {
        Get.to(NovaSenhaPage());
      } else {
        Get.snackbar(
          'Erro',
          'Código inválido',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao verificar código',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
