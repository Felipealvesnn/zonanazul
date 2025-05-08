import 'package:get/get.dart';

import '../controllers/estacionar_controller.dart';

class EstacionarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EstacionarController>(
      () => EstacionarController(),
    );
  }
}
