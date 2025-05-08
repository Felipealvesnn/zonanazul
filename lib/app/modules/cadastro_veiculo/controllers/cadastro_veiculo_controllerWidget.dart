import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/data/repository/login_repository.dart';
import 'package:zona_azul/app/data/repository/veiculo_repository.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/meus_veiculos/controllers/meus_veiculos_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class VeiculoControllerWidget extends GetxController {
  final VeiculoRepository repository = VeiculoRepository();
  HomeController homeController = HomeController();
   MeusVeiculosController meusVeiculosController =
      MeusVeiculosController();
  final loginrepository = Get.put(LoginRepository());
  final boxListVeic = GetStorage('boxListVeic');
  RxList<Veiculo> listveic = <Veiculo>[].obs;

  //TextEditingController passwordTextController = TextEditingController();
  late String passwordTextController;
  late String placaTextController;
  late String modeloTextController;

  RxString tipoDeVeiculo = "carro".obs;
  RxString urlImageButton = "assets/icons/car.png".obs;

  RxString titleTextButton = "carro".obs;

  final boxcpf = GetStorage('cpfCnpj');
  final boxToken = GetStorage('token');
  final boxtipoVeic = GetStorage('tipoVeic');
  final listaVeic = GetStorage('listaVeic');
  RxBool loading = false.obs;
  RxBool loadingUpdate = false.obs;
  RxBool possuiUmVeiculoOuMais = false.obs;

  void cadastrar() async {
    var cpf = boxcpf.read('cpfCnpj');
    var token = boxToken.read('token');

    try {
      await repository
          .cadastrar(placaTextController, cpf.toString(),
              modeloTextController.toString(), token.toString())
          .then((veic) {
        Get.snackbar(
          "Sucesso ",
          "Cadastro realizado com sucesso!",
          colorText: Colors.white,
          backgroundColor: successColor,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
        /*  Future.delayed(Duration(seconds: 3), () {
          Get.offAllNamed(Routes.HOME);
        }); */

        meusVeiculosController.loadVeiculos();
        loading.value = false;
            }).catchError((err) {
        loading.value = false;
      });
    } catch (e) {
      Get.snackbar(
        "Erro ",
        e.toString(),
        colorText: Colors.white,
        backgroundColor: successColor,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void updateVeiculo() async {
    var cpf = boxcpf.read('cpfCnpj');
    var token = boxToken.read('token');

    await repository
        .atualizar(placaTextController, cpf.toString(),
            modeloTextController.toString(), token.toString())
        .then((veic) {
      if (veic != null) {}
    }).catchError((err) {
      //loading.value = false;
      Get.snackbar(
        "Erro ",
        "$err",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 12),
        snackPosition: SnackPosition.TOP,
      );
    });
  }

  void loadEditarVeiculo() async {}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
  listagemVeiculos() async {
    var cpf = boxcpf.read('cpfCnpj');
    var token = boxToken.read('token');

    await repository.listarVeiculo(cpf, token).then((veic) {
      print(veic);
    }).catchError((err) {
      //loading.value = false;

      print("erro listagemVeiculos()");
      Get.snackbar(
        "Erro ",
        "erro oo listar $err",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 12),
        snackPosition: SnackPosition.TOP,
      );
    });
    // }
  }

  void verificaSaldoVeiculos(context) async {
    //busca lista de veiculos na api
    var cpf = boxcpf.read('cpfCnpj');
    var token = boxToken.read('token');

    try {
      await loginrepository.getUsuario(token, cpf).then((usuario) {
        boxListVeic.write('boxListVeic', usuario!.veiculo);
            });

      listveic.value = boxListVeic.read('boxListVeic');
      if (listveic.value.isNotEmpty && listveic.value.isNotEmpty) {
        possuiUmVeiculoOuMais.value = true;
      } else {
        possuiUmVeiculoOuMais.value = false;
      }

      if (possuiUmVeiculoOuMais.value == true) {
        homeController.exibirTelaIntroducao.value = false;
          Storagerds.boxExibirTelaIntroducao
            .write('boxExibirTelaIntroducao', false);
        meusVeiculosController.loadVeiculos();

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const SimpleDialog(
                backgroundColor: Colors.transparent,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            });

        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(Routes.HOME);
            Storagerds.boxExibirTelaIntroducao
              .write('boxExibirTelaIntroducao', false);
          homeController.exibirTelaIntroducao.value = false;
        });
      } else {
        Get.snackbar("Atenção",
            "Você ainda não possui nenhum veiculo, cadastre para começar",
            duration: const Duration(seconds: 3),
            colorText: Colors.white,
            backgroundColor: errorColor);
        Future.delayed(
            const Duration(seconds: 4), () => Get.offAllNamed(Routes.INTRODUCAO));
      }
    } catch (e) {
      Get.snackbar("Atenção", "$e");
    }
  }
}
