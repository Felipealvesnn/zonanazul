import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/models/ListaVeiculosFipe.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/data/repository/veiculo_repository.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/meus_veiculos/controllers/meus_veiculos_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class VeiculoController extends GetxController {
  final VeiculoRepository repository = VeiculoRepository();
  final veiculoRepository = VeiculoRepository();
  List<String> listaModeloVeiculo = [];
  HomeController homeController = HomeController();
  MeusVeiculosController meusVeiculosController =
      Get.find<MeusVeiculosController>();

  //TextEditingController passwordTextController = TextEditingController();
  late String passwordTextController;
  late String placaTextController;
  late String modeloTextController;

  RxString tipoDeVeiculo = "carro".obs;
  RxString urlImageButton = "assets/icons/car.png".obs;

  RxString titleTextButton = "carro".obs;

  final boxcpf = GetStorage('cpfCnpj');
  final boxToken = GetStorage('token');

  RxBool loading = false.obs;
  RxBool loadingUpdate = false.obs;

  @override
  void onInit() async {
    // await GetListaNomeVeiculos();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> GetListaNomeVeiculos() async {
    final boxlist = Storagerds.boxListVeic.read('boxListNomeCarro');

    if (boxlist == null || boxlist.isEmpty) {
      List<ListaVeiculosFipe> tess =
          await veiculoRepository.GetListaNomeVeiculos();
      var listNome = ListaVeiculosFipe.devolveListaNomes(tess);
      Storagerds.boxListVeic.write('boxListNomeCarro', listNome);
      listaModeloVeiculo = listNome;
    } else {
      // Limpa a lista existente antes de adicionar os novos itens
      listaModeloVeiculo.clear();

      // Itera sobre os itens do boxlist e adiciona-os à listaModeloVeiculo
      boxlist.forEach((item) {
        listaModeloVeiculo.add(item);
      });
    }
  }

  void carregarNomeLIstVeiculos(data) {
    if (data is List<String>) {
      listaModeloVeiculo = data;
    } else if (data is List) {
      // data é um mapa
      // listaModeloVeiculo = ListaVeiculosFipe.devolveListaNomes(data);
    }
  }

  void cadastrar() async {
    var cpf = boxcpf.read('cpfCnpj');
    var token = boxToken.read('token');

    try {
      await repository
          .cadastrar(placaTextController, cpf.toString(),
              modeloTextController.toString(), token.toString())
          .then((veic) {
        if (veic != null) {
          Get.snackbar(
            "Sucesso ",
            "Cadastro realizado com sucesso!",
            colorText: Colors.white,
            backgroundColor: successColor,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          );
          Future.delayed(Duration(seconds: 3), () {
            meusVeiculosController.loadVeiculos();
            Get.offAllNamed(Routes.HOME);

            loading.value = false;
          });
        }
      }).catchError((err) {
        loading.value = false;
      });
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        "Erro ",
        "${e.toString()}",
        colorText: Colors.white,
        backgroundColor: successColor,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> updateVeiculoImprovisado() async {
    var cpf = boxcpf.read('cpfCnpj');
    var token = boxToken.read('token');
    Veiculo placaAntiga =
        Storagerds.boxListVeic.read('VeicSelecionado') as Veiculo;

    var retorno = await meusVeiculosController.deleteVeiculo(
        placaAntiga.placa!, cpf, token);

    try {
      await repository
          .cadastrar(placaTextController, cpf.toString(),
              modeloTextController.toString(), token.toString())
          .then((veic) {
        if (veic != null) {
          Get.snackbar(
            "Sucesso ",
            "Carro editado com sucesso!",
            colorText: Colors.white,
            backgroundColor: successColor,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          );
          Future.delayed(Duration(seconds: 3), () async {
            await meusVeiculosController.loadVeiculos();
            //  Get.offAllNamed(Routes.HOME);

            loading.value = false;
          });
        }
      }).catchError((err) {
        loading.value = false;
      });
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        "Erro ",
        " ",
        colorText: Colors.white,
        backgroundColor: successColor,
        duration: Duration(seconds: 3),
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
        duration: Duration(seconds: 12),
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
        "erro oo listar ${err}",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: Duration(seconds: 12),
        snackPosition: SnackPosition.TOP,
      );
    });
    // }
  }
}
