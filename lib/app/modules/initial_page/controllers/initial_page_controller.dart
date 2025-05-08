import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/controllers/cadastro_veiculo_controllerWidget.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';

import 'package:zona_azul/app/modules/login_page/controllers/login_page_controller.dart';
import 'package:zona_azul/app/modules/meus_veiculos/controllers/meus_veiculos_controller.dart';

import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class InitialPageController extends GetxController {
  LoginPageController loginController = LoginPageController();
  HomeController homeController = HomeController();
  CartaoCreditoController cartaoCreditoController = CartaoCreditoController();
  MeusVeiculosController meusVeiculosController = MeusVeiculosController();
  HistoricoController historicoController = HistoricoController();
  final boxExibirTelaIntroducao = GetStorage("boxExibirTelaIntroducao");
  VeiculoControllerWidget veiculoControllerWidget = VeiculoControllerWidget();

  final boxEmailUsuario = GetStorage('emailUsuario');
  final boxSenhalUsuario = GetStorage('senhaUsuario');
  final boxSaldo = GetStorage('saldo');
  final boxMostrarTelaBoasVindas = GetStorage('boxMostrarTelaBoasVindas');

  Future verifyAuth() async {
    var biometria = Storagerds.boxBiometria.read('biometria');
    var dados = Storagerds.boxUserLogado.read('boxUserLogado');

 
    if (dados != null) {
      if (biometria ?? true) {
        await Get.offAllNamed(Routes.WELCOME_PAGE);
        //return await authenticateWithBiometrics();
      }

 
      await Get.offAllNamed(Routes.HOME);

    } else {
      await Get.offAllNamed(Routes.WELCOME);

      //return const WelcomeView();
    }
  }

 
  Future<void> authenticateWithBiometrics() async {
    final LocalAuthentication localAuth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();

        if (availableBiometrics.isNotEmpty) {
          final bool isAuthenticated = await localAuth.authenticate(
            localizedReason: 'Por favor autentique para entrar no app',
            options: const AuthenticationOptions(biometricOnly: true),
          );

          if (isAuthenticated) {
            Storagerds.boxBiometria.write('biometria', true);
            await Get.offAllNamed(Routes.HOME, arguments: false);
          } else {
            return;
            bool? tryAgain = await Get.dialog<bool>(
              AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Biometria falhou'),
                content:
                    Text('Deseja tentar novamente a autenticação biométrica?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.back(
                          result: true); // Retorna true para tentar novamente
                    },
                    child: Text('Tentar novamente'),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back(
                          result:
                              false); // Retorna false para ir para a tela de login
                    },
                    child: Text('Ir para o login'),
                  ),
                ],
              ),
            );

            if (tryAgain == null || tryAgain == true) {
              // Tentar novamente
              return authenticateWithBiometrics();
            } else {
              // Ir para a tela de login
             // boxBiometria.write('biometria', false);
              homeController.logout();
              //return await Get.offAndToNamed(Routes.LOGIN_PAGE);
            }
          }
        } else {
          // O dispositivo não suporta autenticação por impressão digital
        }
      } else {
        // O dispositivo não suporta autenticação biométrica
      }
    } on PlatformException catch (e) {
      // Lidar com exceções, se houver
      print("Erro na autenticação biométrica: $e");
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    //  verifyAuth();
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //  verifyAuth();
  }

  @override
  void onClose() {}
}
