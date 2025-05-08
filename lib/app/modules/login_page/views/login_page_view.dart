import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zona_azul/app/data/global/widgets/rounded_input_field.dart';
import 'package:zona_azul/app/data/global/widgets/rounded_password_field.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/theme/tema.dart';

import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  TextEditingController myEmailController = TextEditingController();
  TextEditingController myPasswordController = TextEditingController();

  RxBool showPassword = true.obs;

  LoginPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      // backgroundColor: Color(0xFF252aff),
      body: Center(
        child: Form(
          key: controller.formKey,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/3-login3.jpg"),
                  fit: BoxFit.fill,
                )),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Não possui conta?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Get.toNamed(Routes.CADASTRO_USUARIO_PAGE);
                          },
                          child: const Text(
                            ' Cadastre-se,',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              // decoration: TextDecoration.underline,
                              decorationThickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13.0),
                    //------------------------------------<FIELDS>----------------------------------------------
                    TextFormField(
                      validator: Validatorless.multiple([
                        Validatorless.required("E-mail Obrigatório"),
                        Validatorless.email("E-mail Inválido"),
                      ]),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      controller: myEmailController,
                      //initialValue: "",

                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Get.theme.primaryColor,
                          ),
                          errorStyle: const TextStyle(color: Colors.yellow),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "E-mail",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(13))),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Obx(
                      () => TextFormField(
                        validator: Validatorless.multiple([
                          Validatorless.required("Senha Obrigatória"),
                          Validatorless.min(
                              3, "Senha precisa ter pelo menos 3 caracteres")
                        ]),
                        controller: myPasswordController,
                        autofocus: false,
                        obscureText: showPassword.value,
                        //initialValue: "Sua senha",
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Get.theme.primaryColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.visibility,
                                color: Get.theme.primaryColor,
                              ),
                              onPressed: () {
                                showPassword.value = !showPassword.value;
                              },
                            ),
                            errorStyle: const TextStyle(color: Colors.yellow),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Senha",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13))),
                      ),
                    ),
                    const SizedBox(height: 13),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Get.toNamed(Routes.ESQUECER_SENHA);
                      },
                      child: const Text(
                        ' Esqueceu a senha?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          // decoration: TextDecoration.underline,
                          decorationThickness: 1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Obx(() => Switch(
                              value: controller.isSwitched.value,
                              onChanged: (value) {
                                controller.isSwitched.value = value;
                              },
                              activeColor: Colors.white,
                              inactiveThumbColor: Colors.white,
                              // track é o backgounrd do seitch
                              inactiveTrackColor: appTema.primaryColor,
                              activeTrackColor: appTema.primaryColor,
                              trackOutlineColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white,
                              ),
                            )),
                        Obx(() => Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: controller.isSwitched.value
                                  ? const Text(
                                      'Biometria Ativada',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    )
                                  : const Text(
                                      'Biometria Desativada',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                            )),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Obx(
                        () => Visibility(
                          visible: !controller.loading.value,
                          replacement: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFffcc43),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              padding: EdgeInsets.zero,
                              minimumSize:
                                  const Size.fromHeight(70), // altura fixa
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  // deixa o spinner mais fino e da cor branca
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              //primary: Color.fromARGB(255, 129, 212, 250),
                              backgroundColor: const Color(0xFFffcc43),
                              //onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              padding: const EdgeInsets.all(12),
                            ),
                            onPressed: () async {
                              //Get.offAllNamed(Routes.HOME);
                              /* cont.emailTextController =
                                  myController.text as TextEditingController;*/
                              controller.emailTextController =
                                  myEmailController.text;
                              controller.passwordTextController =
                                  myPasswordController.text;
                              await controller.login();
                            },
                            child: const Text(
                              'LOGIN',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 13),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
