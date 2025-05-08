import 'package:get/get.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/controllers/cadastro_veiculo_controllerWidget.dart';

class CadastroVeiculoBindingWidget extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VeiculoControllerWidget>(
      () => VeiculoControllerWidget(),
    );
  }
}
