import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:zona_azul/app/modules/esquecerSenha/views/widgets/codigoRecebido.dart';
import 'package:zona_azul/app/modules/esquecerSenha/views/widgets/digitarEmail.dart';

import '../controllers/esquecer_senha_controller.dart';

class EsquecerSenhaView extends GetView<EsquecerSenhaController> {
  @override
  var controller = Get.find();
  EsquecerSenhaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          DigitarEmail(),
          const SizedBox(
            height: 50,
          ),
          Obx(() => Visibility(
              visible: !controller.emailNaoEnviado.value,
              child: codigoRecebido())),
        ],
      ),
    );
  }
}
