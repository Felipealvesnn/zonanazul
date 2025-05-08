import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/theme/app_theme.dart';

class GetXSwitchStateListPagamentoButton extends GetxController {
  var isSwitched = false;
  final switchDataGetXSwitchStateListPagamentoButton = GetStorage();

  GetXSwitchStateSheetFormaPGM() {
    print("Constructor bottonSheetFormaPAgamento called");
    if (switchDataGetXSwitchStateListPagamentoButton
            .read('switchDataGetXSwitchStateListPagamentoButton') !=
        null) {
      isSwitched = switchDataGetXSwitchStateListPagamentoButton
          .read('switchDataGetXSwitchStateListPagamentoButton');
      update();
    }
  }

  changeSwitchSate(bool value) {
    isSwitched = value;
    switchDataGetXSwitchStateListPagamentoButton.write(
        'switchDataGetXSwitchStateListPagamentoButton', isSwitched);
    if (isSwitched == false) {
      Get.changeTheme(appThemeData);
    } else {
      Get.changeTheme(ThemeData.dark());
    }

    update();
  }
}
