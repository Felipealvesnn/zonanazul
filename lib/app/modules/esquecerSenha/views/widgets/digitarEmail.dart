import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zona_azul/app/modules/esquecerSenha/controllers/esquecer_senha_controller.dart';

class DigitarEmail extends StatelessWidget {
  DigitarEmail({Key? key}) : super(key: key);

  final EsquecerSenhaController controller =
      Get.find<EsquecerSenhaController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController myEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          const Text(
            'Resetar senha',
            style: TextStyle(
              fontSize: 32,
              color: Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            'Por favor, digite seu email para resetar sua senha.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextFormField(
              controller: myEmailController,
              validator: Validatorless.multiple([
                Validatorless.required("E-mail Obrigatório"),
                Validatorless.email("E-mail Inválido"),
              ]),
              decoration: const InputDecoration(
                hintText: 'E-mail',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.botaoEmailEnviado.value
                      ? const Color(0xFFffcc43)
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: controller.botaoEmailEnviado.value
                    ? () async {
                        if (formKey.currentState!.validate()) {
                          await controller
                              .resetPassword(myEmailController.text);
                        }
                      }
                    : null,
                child: controller.botaoEmailEnviado.value
                    ? const Text(
                        'ENVIAR',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ENVIAR NOVAMENTE EM:',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Obx(() => Text(
                                '${controller.segundosRestantes.value}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                          const Text(
                            's',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
              )),
        ],
      ),
    );
  }
}
