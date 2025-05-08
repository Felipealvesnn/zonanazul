import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/global/validator.dart';
import 'package:zona_azul/app/modules/cadastroUsuarioEditar/views/widgets/customButomEditar.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/modules/comprar_cad/views/comprar_cad_view.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/theme/tema.dart';

import '../controllers/cadastro_usuario_editar_controller.dart';

class CadastroUsuarioEditarView
    extends GetView<CadastroUsuarioEditarController> {
  final _chaveFormulario = GlobalKey<FormState>();
  String? nomeAtual, cpfAtual, celularAtual, emailAtual;
  CadastroUsuarioEditarView(
      {super.key,
      this.nomeAtual,
      this.cpfAtual,
      this.celularAtual,
      this.emailAtual});

  @override
  Widget build(BuildContext context) {
    var myControllernome = TextEditingController(text: nomeAtual.toString());
    var myControllercpfCnpj = TextEditingController(text: cpfAtual.toString());
    var myControllercelular =
        TextEditingController(text: celularAtual.toString());
    var myControllerEmail = TextEditingController(text: emailAtual.toString());
    var myControllerPassword = TextEditingController();
    var myControllerPasswordConfirm = TextEditingController();

    return PopScope (
      canPop: false,
      onPopInvoked: (didPop) {
        sair();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Informações de usuário",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _chaveFormulario,
            child: ListView(
              shrinkWrap: true,
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 8,
                ),
                //
                //*********************************CAmpos*********************************************************** */
                //

                TextFormField(
                  controller: myControllernome,
                  decoration: const InputDecoration(hintText: "Nome"),
                  validator: Validatorless.required("Nome Obrigatório"),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                    controller: myControllercpfCnpj,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "CPF"),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      //CpfInputFormatter(),
                    ],
                    validator: Validatorless.multiple([
                      Validatorless.required("CPF obrigatório"),
                      Validatorless.cpf("Digite um CPF válido"),
                    ])),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                    controller: myControllercelular,
                    //colocar mascara para ddd (xx) xxxxxxxxxxx
                    inputFormatters: [
                      TextInputMask(
                          mask: ['(99) 9999 9999', '(99) 99999 9999'],
                          reverse: false)
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Celular"),
                    validator: Validatorless.multiple([
                      Validatorless.required("Digite um numero de celular"),
                      Validatorless.min(15, "Numero incompleto"),
                    ])),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                    controller: myControllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: "Email"),
                    validator: Validatorless.multiple([
                      Validatorless.required("E-mail Obrigatório"),
                      Validatorless.email("E-mail Inválido"),
                    ])),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                    controller: myControllerPassword,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: "Senha (mínimo 3 dígitos)"),
                    validator: Validatorless.multiple([
                      Validatorless.required("Senha Obrigatória"),
                      Validatorless.min(
                          3, "Senha precisa ter pelo menos 3 caracteres")
                    ])),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: myControllerPasswordConfirm,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration:
                      const InputDecoration(hintText: "Confirme sua senha"),
                  validator: Validatorless.multiple([
                    Validatorless.required("Senha Obrigatória"),
                    Validatorless.min(
                        3, "Senha precisa ter pelo menos 3 caracteres"),
                    Validators.compare(
                        myControllerPassword, "Senhas diferentes")
                  ]),
                ),
                const SizedBox(
                  height: 12,
                ),
                //
                //*****************************************Botões*****************************************************/
                //

                Obx(
                  () => Visibility(
                    visible: !controller.loading.value,
                    replacement: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomElevatedButton(
                        style: _cadastrarButtonStyle(),
                        buttonText: 'Atualizar',
                        onPressed: () {},
                        isLoading: true,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomElevatedButton(
                        style: _cadastrarButtonStyle(),
                        buttonText: 'Atualizar',
                        onPressed: () {
                          controller.loading.value = true;
                          var formValid =
                              _chaveFormulario.currentState?.validate() ??
                                  false;
                          if (formValid == true) {
                            print("TUDO VALIDADO");
                            Future.delayed(const Duration(seconds: 1), () {
                              controller.atualizarUsuario(
                                  myControllernome.text,
                                  myControllercpfCnpj.text,
                                  myControllercelular.text,
                                  myControllerEmail.text,
                                  myControllerPassword.text,
                                  controller.boxToken.read('token'));
                            });
                          } else {
                            controller.loading.value = false;
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_cadastrarButtonStyle() {
  //estilo do botao cadastrar
  return ButtonStyle(
      //primary: Color.fromARGB(255, 129, 212, 250),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        return const Color(0xFFffcc43);
      }),
      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));
      }));
}

//testes abaixo

_confirmaCadastroSnackbar() {
  Get.snackbar("Parabens", "Usuario Registrado com sucesso",
      backgroundColor: successColor, colorText: Colors.white);
}

_confirmaCadastroBottonSheet() {
  Get.bottomSheet(
    ListTile(
        leading: const Icon(Icons.music_note),
        title: const Text('Músicas'),
        onTap: () => {}),
  );
}

_tocado(context) {
  /* Get.defaultDialog(
      content: SingleChildScrollView(
    child: Column(
      children: [
        Text(
            "1. Aceitação dos Termos e Condições Gerais de Uso do Aplicativo ESTACIONE JÁ")
      ],
    ),
  )); */

  sair() {
    //Get.offAllNamed(Routes.HOME);
  }
}
