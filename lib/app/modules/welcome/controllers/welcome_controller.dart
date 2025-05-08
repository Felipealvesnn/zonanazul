import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/controllers/cadastro_veiculo_controllerWidget.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/initial_page/controllers/initial_page_controller.dart';
import 'package:zona_azul/app/modules/login_page/controllers/login_page_controller.dart';
import 'package:zona_azul/app/modules/meus_veiculos/controllers/meus_veiculos_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';

class WelcomeController extends GetxController {
  LoginPageController loginController = LoginPageController();
  HomeController homeController = HomeController();
  CartaoCreditoController cartaoCreditoController = CartaoCreditoController();
  MeusVeiculosController meusVeiculosController = MeusVeiculosController();
  //HistoricoController historicoController = HistoricoController();
  final boxExibirTelaIntroducao = GetStorage("boxExibirTelaIntroducao");
  VeiculoControllerWidget veiculoControllerWidget = VeiculoControllerWidget();

  final box = GetStorage('cpfCnpj');
  final boxToken = GetStorage('token');
  final boxEmailUsuario = GetStorage('emailUsuario');
  final boxSenhalUsuario = GetStorage('senhaUsuario');
  final boxSaldo = GetStorage('saldo');
  final boxMostrarTelaBoasVindas = GetStorage('boxMostrarTelaBoasVindas');

  verifyAuth() async {
    // var dados = Usuario.fromJson(box.read('usuario'));
    //var dados = box.read('usuario');
    var dados = box.read("cpfCnpj");
    var token = boxToken.read("token");
    print("token: $token");
    if (dados != null) {
      loginController.emailTextController =
          boxEmailUsuario.read('emailUsuario');
      loginController.passwordTextController =
          boxSenhalUsuario.read('senhaUsuario');
      boxSaldo.read('saldo');
      await meusVeiculosController.loadVeiculos();
      //
      //historicoController.loadUltimoHistoricoEstacionamento();

      if (boxExibirTelaIntroducao.read('boxExibirTelaIntroducao') == true) {
        return Future.delayed(const Duration(seconds: 3), () {
          Routes.INTRODUCAO;
        });
      } else {
        Get.offAllNamed(Routes.HOME);

        //  return  HomeView();
      }
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAllNamed(Routes.WELCOME);
      });
      //return const WelcomeView();
    }
  }

  final count = 0.obs;

  @override
  void onReady() {
    //verifyAuth();
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
