import 'package:get/get.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';

import '../controllers/cartao_debito_controller.dart';

class CartaoDebitoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartaoCreditoController>(
      () => CartaoCreditoController(),
    );
  }
}
