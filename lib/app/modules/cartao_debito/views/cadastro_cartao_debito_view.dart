import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class CadastroCartaoDebitoView extends GetView<CartaoCreditoController> {
  //controlladores locais
  var nomeDoTitularEditingController = TextEditingController();
  var numeroCartaoEditingController = TextEditingController();
  var validadeEditingController = TextEditingController();
  var codSeguranEditingController = TextEditingController();

  final _chaveFormularoCartaoCredito = GlobalKey<FormState>();

  CadastroCartaoDebitoView({super.key});

  @override
  Widget build(BuildContext context) {
    var cpfCnpjEditingController =
        TextEditingController(text: Storagerds.boxcpf.read('cpfCnpj'));
    return Form(
      key: _chaveFormularoCartaoCredito,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Cartao de Debito'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            children: [
              //NOME DO TITULAR
              TextFormField(
                controller: nomeDoTitularEditingController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: "NOME DO TITULAR DO CARTÃO",
                    labelStyle: TextStyle(color: Colors.grey[600])),
                validator:
                    Validatorless.required("Nome do titular Obrigatório"),
              ),
              //NUMERO DO CARTAO
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                  controller: numeroCartaoEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.credit_card),
                      labelText: "NÚMERO DO CARTÃO",
                      labelStyle: TextStyle(color: Colors.grey[600])),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CartaoBancarioInputFormatter()
                  ],
                  validator: Validatorless.multiple([
                    Validatorless.required("Número do cartão obrigatório"),
                  ])),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                  //autofocus: true,
                  controller: validadeEditingController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      //hintText: "VALIDADE",
                      labelText: "VALIDADE",
                      hintText: "MM/AA"),
                  validator: Validatorless.required(
                      "Necessário informar a validade do cartão"),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    ValidadeCartaoInputFormatter()
                  ]),
              //NUMERO DO CARTAO
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: codSeguranEditingController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  //hintText: "VALIDADE",
                  labelText: "CÓD. DE SEGURANÇA(CVV)",
                ),
                validator: Validatorless.required(
                    "Necessário informar cód. CVV do cartão"),
                inputFormatters: [
                  TextInputMask(
                      mask: '999',
                      // maxPlaceHolders: 11,
                      reverse: false)
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                  controller: cpfCnpjEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "CPF",
                    prefixIcon: Icon(Icons.format_indent_decrease),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter()
                  ],
                  validator: Validatorless.multiple([
                    Validatorless.required("CPF obrigatório"),
                    Validatorless.cpf("Digite um CPF válido"),
                  ])),
              const SizedBox(
                height: 60,
              ),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock),
                  Text("  Os dados informados ficam criptografados"),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //primary: Color.fromARGB(255, 129, 212, 250),
                    backgroundColor: Colors.deepOrange,
                    //onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: () {
                    _chaveFormularoCartaoCredito.currentState!.validate();
                  },
                  child: const Text(
                    'CONTINUAR',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ],
          )),
    );
  }
}
