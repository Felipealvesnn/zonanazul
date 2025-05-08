import 'package:get/get.dart';

import '../controllers/cadastro_usuario_editar_controller.dart';

class CadastroUsuarioEditarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CadastroUsuarioEditarController>(
      () => CadastroUsuarioEditarController(),
    );
  }
}
