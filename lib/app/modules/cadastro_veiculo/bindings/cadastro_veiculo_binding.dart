import 'package:get/get.dart';

import '../controllers/cadastro_veiculo_controller.dart';

class CadastroVeiculoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VeiculoController>(
      () => VeiculoController(),
    );
  }
}
