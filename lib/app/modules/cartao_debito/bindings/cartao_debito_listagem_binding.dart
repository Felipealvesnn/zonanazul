import 'package:get/get.dart';

import '../controllers/cartao_debito_controller.dart';

class CartaoDebitoListagemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartaoDebitoController>(
      () => CartaoDebitoController(),
    );
  }
}
