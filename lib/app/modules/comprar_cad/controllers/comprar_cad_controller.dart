import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';

class ComprarCadController extends GetxController {
  RxBool pagando = false.obs;
  HomeController homeController = HomeController();
  CartaoCreditoController cartaoCreditoController = CartaoCreditoController();
  final boxCamposValidadosEstacionar = GetStorage('CamposValidadosEstacionar');
  //TODO: Implement ComprarCadController

  final count = 0.obs;
  @override
  void onInit() {
    homeController.carregarCad;
   // cartaoCreditoController.loadCartoes();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    boxCamposValidadosEstacionar.write('regraEstacionamendoID', "Selecione");
  }

  void increment() => count.value++;
}
