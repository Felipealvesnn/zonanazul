import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/modules/meus_veiculos/controllers/meus_veiculos_controller.dart';
import 'package:zona_azul/app/theme/app_theme.dart';
import 'package:zona_azul/app/theme/tema.dart';

class GetXSwitchState extends GetxController {
  final boxTema = GetStorage("boxTema");

  var isSwitched = false;
  final switchDataController = GetStorage();
  RxBool textMeusCads = true.obs;

  GetXSwitchState() {
    print("Constructor called");
    if (switchDataController.read('getxIsSwitched') != null) {
      isSwitched = switchDataController.read('getxIsSwitched');
      update();
    }
  }

  changeSwitchSate(bool value) {
    isSwitched = value;
    switchDataController.write('getxIsSwitched', isSwitched);
    if (isSwitched == false) {
      //Get.changeTheme(appThemeData);
      Get.changeTheme(appTema);
      boxTema.write('boxTema', "light");
      textMeusCads.value = true;
      homeController.temaEscuro.value = false;
    } else {
      // Get.changeTheme(ThemeData.dark());
      Get.changeTheme(appTemaDark);
      boxTema.write('boxTema', "dark");

      textMeusCads.value = false;
      homeController.temaEscuro.value = true;
      homeController.corButtonAddVeic.value = false;
    }

    update();
  }
}
