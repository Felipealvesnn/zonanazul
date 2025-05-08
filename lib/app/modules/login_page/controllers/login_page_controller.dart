import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/data/repository/login_repository.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/meus_veiculos/controllers/meus_veiculos_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:zona_azul/app/utils/funcoesutilsd.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class LoginPageController extends GetxController {
  //final repository = Get.find<LoginRepository>();
  final repository = Get.put(LoginRepository());
  HomeController homeController = HomeController();
  MeusVeiculosController meusVeiculosController = MeusVeiculosController();
  CartaoCreditoController cartaoCreditoController = CartaoCreditoController();
  HistoricoController historicoController = HistoricoController();

  final loginrepository = Get.put(LoginRepository());
  final boxListVeic = GetStorage('boxListVeic');
  RxBool isSwitched = false.obs;

  RxList<Veiculo> listveic = <Veiculo>[].obs;
  RxBool possuiUmVeiculoOuMais = false.obs;

  final formKey = GlobalKey<FormState>();
  RxBool loading = false.obs;

  late String emailTextController;
  late String nomeTextController;
  late String cpfCnpjTextController;
  late String celularTextController;
  late String passwordTextController;

  //final boxUserLogado = GetStorage('boxUserLogado');

  final boxExibirTelaIntroducao = GetStorage("boxExibirTelaIntroducao");

  Future<void> testarApi() async {
    try {
      final result = await InternetAddress.lookup("www.google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      } else {
        Get.snackbar("Sem conexão com a Internet", "Varifique sua conexão ",
            colorText: Colors.white,
            backgroundColor: errorColor,
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.TOP);
      }
    } on SocketException catch (_) {
      print('not connected');
      Get.snackbar("Sem conexão com a Internet",
          "Varifique sua conexão e tente novamente",
          colorText: Colors.white,
          backgroundColor: errorColor,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP);
    }

    //-------------verificar apartir daqui----------------
  }

  Future<void> login() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      final connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet) {
        print("Conectado à rede");
        loading.value = true;
        final usuario =
            await repository.login(emailTextController, passwordTextController);

        if (usuario.token != null && usuario.cpfcnpj != null) {
          // Armazena os dados do usuário
          Storagerds.boxUserLogado.write('boxUserLogado', usuario);
          Storagerds.boxBiometria.write('biometria', isSwitched.value);
          Storagerds.boxcpf.write('cpfCnpj', usuario.cpfcnpj);
          Storagerds.boxToken.write('token', usuario.token);
          Storagerds.boxnomeUsuario.write('nomeUsuario', usuario.nome);
          Storagerds.boxEmailUsuario.write('emailUsuario', usuario.email);
          Storagerds.boxSenhalUsuario.write('senhaUsuario', usuario.senha);
          Storagerds.boxSaldo.write('saldo', usuario.conta?.first.saldo);

          // Carrega informações adicionais
          //  await homeController.loadVeiculos();
          //  await cartaoCreditoController.loadCartoes();
          // await historicoController.loadUltimoHistoricoEstacionamento();

          if (boxExibirTelaIntroducao.read('boxExibirTelaIntroducao') == null ||
              boxExibirTelaIntroducao.read('boxExibirTelaIntroducao') == true) {
            verificaSaldoVeiculosLoginController();
          } else {
            boxExibirTelaIntroducao.write('boxExibirTelaIntroducao', false);
            homeController.exibirTelaIntroducao.value = false;
            print("HOME");
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          Get.snackbar("Usuário ou senha inválidos", "Tente novamente",
              colorText: Colors.white,
              backgroundColor: errorColor,
              duration: const Duration(seconds: 10),
              snackPosition: SnackPosition.TOP);
        }
      } else {
        print("Não conectado à wifi ou 3G");
        Get.snackbar("Sem conexão com a Internet", "Verifique sua conexão",
            colorText: Colors.white,
            backgroundColor: errorColor,
            duration: const Duration(seconds: 10),
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      // Get.snackbar("Erro", e.toString(),
      //     colorText: Colors.white,
      //     backgroundColor: errorColor,
      //     duration: const Duration(seconds: 10),
      //     snackPosition: SnackPosition.TOP);
    } finally {
      loading.value = false;
    }
  }

  void refreshToken() async {
    await repository
        .login(emailTextController, passwordTextController)
        .then((usuario) {
      Storagerds.boxcpf.write('cpfCnpj', usuario.cpfcnpj);
      Storagerds.boxToken.write('token', usuario.token);

      Storagerds.boxnomeUsuario.write('nomeUsuario', usuario.nome);
      Storagerds.boxEmailUsuario.write('emailUsuario', usuario.email);
      Storagerds.boxSenhalUsuario.write('senhaUsuario', usuario.senha);
    }).catchError((err) {
      loading.value = false;
      // Get.defaultDialog(title: "Falha na validação", content: Text("Err: ${err}"));
      //Get.defaultDialog(title: "Falha na validação",content: Text("Por favor verifique login e senha."));
      Get.snackbar("Falha na validação do token", "Refaça seu login",
          colorText: Colors.white,
          backgroundColor: errorColor,
          duration: const Duration(seconds: 6),
          snackPosition: SnackPosition.TOP);
    });

    final count = 0.obs;
    @override
    void onInit() {
      FuncoesParaAjudar.recuperaPosition();
      super.onInit();
    }

    @override
    void onReady() {
      super.onReady();
    }

    @override
    void onClose() {}
    void increment() => count.value++;
  }

  verificaConexoes() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("conectado a rede");
    } else {
      print("nao conectado a wifi ou 3g");

      Get.snackbar("Sem conexão com a Internet", "Varifique sua conexão ",
          colorText: Colors.white,
          backgroundColor: errorColor,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP);
    }
  }

// Defina um método assíncrono para verificar o saldo dos veículos
  Future<void> verificaSaldoVeiculosLoginController() async {
    try {
      final cpf = Storagerds.boxcpf.read('cpfCnpj');
      final token = Storagerds.boxToken.read('token');

      final usuario = await loginrepository.getUsuario(token, cpf);

      if (usuario!.veiculo!.isNotEmpty) {
        boxListVeic.write('boxListVeic', usuario.veiculo);
        listveic.value = usuario.veiculo!;

        if (listveic.value.isNotEmpty) {
          Get.offAllNamed(Routes.INTRO2);
          possuiUmVeiculoOuMais.value = true;
        } else {
          Get.offAllNamed(Routes.INTRODUCAO);
          possuiUmVeiculoOuMais.value = false;
        }
      } else {
        Get.offAllNamed(Routes.INTRODUCAO);
        possuiUmVeiculoOuMais.value = false;
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar("Atenção", "$e");
    }
  }

  loginAtualizar(String email, String Password) async {
    try {
      await repository.login(email, Password).then((usuario) {
        if (usuario.token != null && usuario.cpfcnpj != null) {
          //teste user inteiro
          Storagerds.boxUserLogado.write('boxUserLogado', usuario);

          Storagerds.boxcpf.write('cpfCnpj', usuario.cpfcnpj);
          Storagerds.boxToken.write('token', usuario.token);
          Storagerds.boxnomeUsuario.write('nomeUsuario', usuario.nome);
          Storagerds.boxEmailUsuario.write('emailUsuario', usuario.email);
          Storagerds.boxSenhalUsuario.write('senhaUsuario', usuario.senha);
          Storagerds.boxSaldo.write('saldo', usuario.conta?.first.saldo);

          meusVeiculosController.loadVeiculos();
          cartaoCreditoController.loadCartoes();

          homeController.loadUltimoHistoricoEstacionamento();

          if (boxExibirTelaIntroducao.read('boxExibirTelaIntroducao') == null ||
              boxExibirTelaIntroducao.read('boxExibirTelaIntroducao') == true) {
            verificaSaldoVeiculosLoginController();
          } else {
            boxExibirTelaIntroducao.write('boxExibirTelaIntroducao', false);
            homeController.exibirTelaIntroducao.value = false;
            print("HOME");
            Future.delayed(
                const Duration(seconds: 2), () => Get.offAllNamed(Routes.HOME));
          }
          /* Future.delayed(
                Duration(seconds: 2), () => Get.offAllNamed(Routes.HOME)); */
        } else {
          Get.snackbar("Usuário ou senha inválidos", "Tente novamente",
              colorText: Colors.white,
              backgroundColor: errorColor,
              duration: const Duration(seconds: 10),
              snackPosition: SnackPosition.TOP);
        }
      });
    } catch (e) {
      Get.snackbar("erro", e.toString(),
          duration: const Duration(seconds: 3), backgroundColor: errorColor);
    }
  }
}
