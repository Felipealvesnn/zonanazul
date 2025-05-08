import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zona_azul/app/modules/esquecerSenha/controllers/esquecer_senha_controller.dart';

class codigoRecebido extends StatelessWidget {
  codigoRecebido({super.key});
  EsquecerSenhaController controller = Get.find<EsquecerSenhaController>();
  final formKey = GlobalKey<FormState>();

  TextEditingController myEmailController = TextEditingController();
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
            'Codigo Enviado ',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            'Por favor, digite o codigo recebido.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextFormField(
              controller: myEmailController,
              decoration: const InputDecoration(
                hintText: 'Codigo Recebido',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              //primary: Color.fromARGB(255, 129, 212, 250),
              backgroundColor: Colors.green,
              //onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.all(12),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                controller.verificarCodigo(myEmailController.text);
              }
            },
            child: const Text(
              'Enviar',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
