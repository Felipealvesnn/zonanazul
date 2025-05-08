
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/getStorages.dart';
import '../controllers/initial_page_controller.dart';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

class InitialPage extends GetView<InitialPageController> {
  final initialPageController = Get.put(InitialPageController());
  var dados = Storagerds.boxcpf.read("cpfCnpj");
  var biometria = Storagerds.boxBiometria.read('biometria');
  InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    var introducao =
        Storagerds.boxExibirTelaIntroducao.read("boxExibirTelaIntroducao") ??
            false;
    return Scaffold(
      //  appBar: AppBar(title: Text('Initial Page')),
      body: FlutterSplashScreen.fadeIn(
        duration: introducao
            ? const Duration(seconds: 2)
            : const Duration(milliseconds: 0),
        animationDuration: introducao
            ? const Duration(seconds: 2)
            : const Duration(milliseconds: 0),
        backgroundColor: Colors.white,
        onInit: () async {
          debugPrint("On Init");
        },
        onEnd: () async {
          debugPrint("On End");
          await initialPageController.verifyAuth();
        },
        childWidget: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Image.asset("assets/2-welcome2.jpg", fit: BoxFit.cover),
        ),
        onAnimationEnd: () => debugPrint("On Fade In End"),
        //  nextScreen: WelcomePageView(),
      ),
    );
  }
}
