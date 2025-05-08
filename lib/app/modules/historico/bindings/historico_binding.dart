import 'package:get/get.dart';

import '../controllers/historico_controller.dart';

class HistoricoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoricoController>(
      () => HistoricoController(),
    );
  }
}
