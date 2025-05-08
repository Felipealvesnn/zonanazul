import 'dart:ffi';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zona_azul/app/modules/pagamento/controllers/pagamento_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';
import '../controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/data/global/constants.dart';

class CadastroCartaoCreditoView extends GetView<PagamentoController> {
  final PagamentoController pagamentoController =
      Get.find<PagamentoController>();

  CadastroCartaoCreditoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: pagamentoController.chaveFormularioCartaoCredito.value,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cartão de Crédito'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildTextFormField(
                controller:
                    pagamentoController.nomeDoTitularEditingController.value,
                labelText: "Nome do Titular do Cartão",
                prefixIcon: const Icon(Icons.person),
                validator:
                    Validatorless.required("Nome do titular obrigatório"),
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller:
                    pagamentoController.numeroCartaoEditingController.value,
                labelText: "Número do Cartão",
                prefixIcon: const Icon(Icons.credit_card),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validatorless.multiple([
                  Validatorless.required("Número do cartão obrigatório"),
                ]),
              ),
              const SizedBox(height: 12),
              _buildValidadeFields(),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller:
                    pagamentoController.codSeguranEditingController.value,
                labelText: "Cód. de Segurança (CVV)",
                prefixIcon: const Icon(Icons.lock),
                keyboardType: TextInputType.number,
                inputFormatters: [TextInputMask(mask: '999', reverse: false)],
                validator: Validatorless.required(
                    "Necessário informar cód. CVV do cartão"),
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: pagamentoController.cpfCnpjEditingController.value,
                labelText: "CPF",
                prefixIcon: const Icon(Icons.list_alt),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter()
                ],
                validator: Validatorless.multiple([
                  Validatorless.required("CPF obrigatório"),
                  Validatorless.cpf("Digite um CPF válido"),
                ]),
              ),
              const SizedBox(height: 60),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock),
                  Text("  Os dados informados ficam criptografados"),
                ],
              ),
              const SizedBox(height: 60),
              _buildElevatedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    Icon? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[600]),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }

  Widget _buildValidadeFields() {
    return Row(
      children: [
        SizedBox(
          width: Get.size.width / 3,
          child: TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 2,
            controller: pagamentoController.mesValidadeEditingController.value,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              labelStyle: TextStyle(color: Colors.grey[600]),
              labelText: "Mês",
              hintText: "MM",
            ),
            validator: Validatorless.required(
                "Necessário informar a validade do cartão"),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ValidadeCartaoInputFormatter()
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: Get.size.width / 3,
          child: TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 2,
            controller: pagamentoController.anoValidadeEditingController.value,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              labelStyle: TextStyle(color: Colors.grey[600]),
              labelText: "Ano",
              hintText: "",
            ),
            validator: Validatorless.required(
                "Necessário informar a validade do cartão"),
          ),
        ),
      ],
    );
  }

  Widget _buildElevatedButton() {
    return Obx(
      () {
        // final isValid = pagamentoController
        //         .chaveFormularioCartaoCredito.value.currentState
        //         ?.validate() ==
        //     true;
        final isLoading = pagamentoController.loading.value;

        return Visibility(
          visible: !isLoading,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFffcc43),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.all(12),
            ),
            onPressed: () async {
              if (pagamentoController
                  .chaveFormularioCartaoCredito.value.currentState!
                  .validate()) {
                pagamentoController
                    .chaveFormularioCartaoCredito.value.currentState!
                    .save();
                await pagamentoController.continuar();
              } else {
                return;
              }
            },
            child: !isLoading
                ? const Text(
                    'CONTINUAR',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                : const SizedBox(
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      },
    );
  }
}
