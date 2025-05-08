import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/models/ListaVeiculosFipe.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/data/repository/login_repository.dart';
import 'package:zona_azul/app/data/repository/veiculo_repository.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class MeusVeiculosController extends GetxController {
  //TODO: Implement MeusVeiculosController
  final repository = Get.find<LoginRepository>();
  final veiculoRepository = VeiculoRepository();
  RxList<Veiculo> listveic = <Veiculo>[].obs;
  RxBool carregandoCarros = true.obs;

  final count = 0.obs;
  @override
  void onInit() async {
    var storedVeiculos = Storagerds.boxListVeic.read('boxListVeic');
    if (storedVeiculos == null || storedVeiculos.isEmpty) {
      await loadVeiculos();
    } else {
      carregarVeiculos(storedVeiculos);
    }
    super.onInit();
  }

  @override
  void onClose() {}

  Future<void> loadVeiculos() async {
    //busca lista de veiculos na api
    carregandoCarros.value = true;
    var cpf = Storagerds.boxcpf.read('cpfCnpj');
    var token = Storagerds.boxToken.read('token');
    try {
      var usuario = await repository.getUsuario(token, cpf);
      if (usuario != null) {
        await Storagerds.boxListVeic.write('boxListVeic', usuario.veiculo);
        if (usuario.veiculo?.isNotEmpty ?? false) {
          listveic.value = usuario.veiculo!;
          print(usuario.veiculo!);
        } else {
          listveic.value = [];
        }
      } else {
        // Trate o caso em que o usuário é nulo
      }
    } catch (err) {
      Get.snackbar("Erro", "${err.toString()} veiculos",
          backgroundColor: errorColor, colorText: Colors.white);
    } finally {
      carregandoCarros.value = false;
    }
  }

  Future deleteVeiculo(String placa, String cpf, String token) async {
    //deletar um veiculo do usuario
    var cpf = Storagerds.boxcpf.read('cpfCnpj');
    var token = Storagerds.boxToken.read('token');

    try {
      var retorno = await veiculoRepository
          .apagarVeiculo(placa, cpf, token)
          .then((veic) async {
        await loadVeiculos();
        return veic;
      }).catchError((err) {});
    } catch (e) {
      Get.snackbar(
        "Erro ",
        e.toString(),
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
    await loadVeiculos();
  }

  carregarVeiculos(data) {
    try {
      carregandoCarros.value = true;

      if (data is List<Veiculo>) {
        listveic.value = data;
      } else if (data is List) {
        // data é um mapa
        final List<Veiculo> VeiculoList = [];

        for (var v in data) {
          VeiculoList.add(Veiculo.fromJson(v));
        }
        Storagerds.boxListVeic.write('boxListVeic', VeiculoList);
        print('data é um mapa');
        listveic.assignAll(VeiculoList);
      }
    } catch (e) {
      print(e);
    } finally {
      carregandoCarros.value = false;
    }
  }
}
