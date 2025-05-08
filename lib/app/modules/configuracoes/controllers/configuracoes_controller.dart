import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class ConfiguracoesController extends GetxController {
  RxBool isSwitched = false.obs;

  @override
  void onInit() {
    var biometria = Storagerds.boxBiometria.read('biometria');
    isSwitched.value = biometria ?? false;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
