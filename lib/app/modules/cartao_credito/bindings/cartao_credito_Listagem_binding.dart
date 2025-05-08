import 'package:get/get.dart';

import '../controllers/cartao_credito_controller.dart';

class CartaoCreditoListagemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartaoCreditoController>(
      () => CartaoCreditoController(),
    );
  }
}
