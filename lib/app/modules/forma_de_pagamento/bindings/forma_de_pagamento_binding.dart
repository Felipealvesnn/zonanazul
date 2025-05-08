import 'package:get/get.dart';

import '../controllers/forma_de_pagamento_controller.dart';

class FormaDePagamentoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormaDePagamentoController>(
      () => FormaDePagamentoController(),
    );
  }
}
