import 'package:get/get.dart';

import '../controllers/meus_veiculos_controller.dart';

class MeusVeiculosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeusVeiculosController>(
      () => MeusVeiculosController(),
    );
  }
}
