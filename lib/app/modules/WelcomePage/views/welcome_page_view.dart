import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/modules/initial_page/controllers/initial_page_controller.dart';

import '../controllers/welcome_page_controller.dart';

class WelcomePageView extends GetView<WelcomePageController> {
  InitialPageController initial_page_controller = InitialPageController();

  WelcomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    initial_page_controller.authenticateWithBiometrics();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/2-welcome2.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 20.0),
                const Text(
                  "...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: Get.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            // Navegar para a próxima tela, por exemplo, a tela de login
                            await initial_page_controller
                                .authenticateWithBiometrics();
                          },
                          child: const Text(
                            "Acessar",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: Get.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () async {
                            // Navegar para a próxima tela, por exemplo, a tela de login
                            await homeController.logout();
                          },
                          child: const Text(
                            "Sair da conta",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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
