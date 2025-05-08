import 'package:get/get.dart';

import '../controllers/cadastro_usuario_page_controller.dart';

class CadastroUsuarioPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CadastroUsuarioPageController>(
      () => CadastroUsuarioPageController(),
    );
  }
}
