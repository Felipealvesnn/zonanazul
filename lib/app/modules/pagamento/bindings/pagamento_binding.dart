import 'package:get/get.dart';

import '../controllers/pagamento_controller.dart';

class PagamentoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PagamentoController>(
      () => PagamentoController(),
    );
  }
}
