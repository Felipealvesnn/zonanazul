import 'package:get/get.dart';

import '../controllers/introducao_controller.dart';

class IntroducaoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroducaoController>(
      () => IntroducaoController(),
    );
  }
}
