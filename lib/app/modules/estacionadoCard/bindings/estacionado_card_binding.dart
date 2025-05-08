import 'package:get/get.dart';

import '../controllers/estacionamentoAtual_card_controller.dart';

class EstacionadoAtualCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EstacionamentoAtualCardController>(
      () => EstacionamentoAtualCardController(),
    );
  }
}
