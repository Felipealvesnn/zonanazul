import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zona_azul/app/data/global/widgets/rounded_button.dart';
import 'package:zona_azul/app/modules/initial_page/controllers/initial_page_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';

import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  WelcomeView({super.key});
  final controller = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Color(0xFF005ca9),//color cx
      backgroundColor: const Color(0xFF252aff),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/2-welcome2.jpg"),
              fit: BoxFit.fill,
            )),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "BEM-VINDO",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xfffbfbff),
                    fontSize: 34,
                    fontFamily: "Work Sans",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Estacione já, simples, fácil e prático",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedButton(
                    text: "CADASTRAR",
                    press: () async {
                      await Get.toNamed(Routes.CADASTRO_USUARIO_PAGE);
                    }),
                TextButton(
                  style: TextButton.styleFrom(
                   backgroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    "Já possuo cadastro",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  onPressed: () async {
                    await Get.toNamed(Routes.LOGIN_PAGE);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
