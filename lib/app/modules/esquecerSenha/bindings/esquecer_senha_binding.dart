import 'package:get/get.dart';

import '../controllers/esquecer_senha_controller.dart';

class EsquecerSenhaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EsquecerSenhaController>(
      () => EsquecerSenhaController(),
    );
  }
}
