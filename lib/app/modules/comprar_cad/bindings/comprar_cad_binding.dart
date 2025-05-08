import 'package:get/get.dart';

import '../controllers/comprar_cad_controller.dart';

class ComprarCadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComprarCadController>(
      () => ComprarCadController(),
    );
  }
}
