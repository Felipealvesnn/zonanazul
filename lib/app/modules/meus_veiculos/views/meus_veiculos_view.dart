import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/controllers/cadastro_veiculo_controller.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/modules/comprar_cad_semBarr.dart/comprar_cad_view_semBarr.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/meus_veiculos/controllers/meus_veiculos_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class MeusVeiculosView extends GetView<VeiculoController> {
  HomeController homeController = Get.find<HomeController>();
  // EstacionarController estacionarController = Get.find<EstacionarController>();
  VeiculoController veiculoController = Get.find<VeiculoController>();
  MeusVeiculosController meusVeiculosController =
      Get.find<MeusVeiculosController>();
  Color? tileColor;

  MeusVeiculosView({super.key});

  void start() {
    meusVeiculosController.loadVeiculos();
    meusVeiculosController.listveic.value =
        Storagerds.boxListVeic.read('boxListVeic');
    if (Storagerds.boxTema.read('boxTema') == "dark") {
      homeController.temaEscuro.value = true;
    } else {
      homeController.temaEscuro.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showAppBar = Get.arguments ?? false;

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text('Meus Veiculos'),
              centerTitle: true,
            )
          : null,
      body: Obx(
        () => RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: reloadList,
          child: meusVeiculosController.carregandoCarros.value
              ? const ShimmerLoadingList()
              : Visibility(
                  visible: meusVeiculosController.listveic.isNotEmpty,
                  replacement: ListView(
                    children: const [
                      Text(
                          'Nenhum veículo cadastrado, por favor cadastre um veículo'),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: meusVeiculosController.listveic.length,
                    itemBuilder: (context, index) {
                      Veiculo veiculo = meusVeiculosController.listveic[index];
                      return buildVeiculoListItem(veiculo, context);
                    },
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.CADASTRO_VEICULO);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildVeiculoListItem(Veiculo veiculo, BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
              onLongPress: () {
                confirmaExcluirVeiculoDialog(
                  context,
                  veiculo.placa!,
                  Storagerds.boxcpf.read('cpfCnpj'),
                  Storagerds.boxToken.read('token'),
                );
              },
              leading: Icon(
                Icons.drive_eta,
                size: 50,
                color: Get.theme.iconTheme.color,
              ),
              title: Text(veiculo.placa.toString()),
              subtitle: Text(veiculo.marca.toString()),
              onTap: () {
                Storagerds.boxListVeic.write('VeicSelecionado', veiculo);
                veiculoController.placaTextController =
                    veiculo.placa.toString();
                Get.to(EditarVeiculoView(
                  placa: veiculo.placa,
                  marca: veiculo.marca,
                  tipoVeiculo: Storagerds.boxtipoVeic.read('tipoVeic'),
                  cpf: veiculoController.boxcpf.read('cpfCnpj'),
                  token: veiculoController.boxToken.read('token'),
                ));
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  confirmaExcluirVeiculoDialog(
                    context,
                    veiculo.placa!,
                    Storagerds.boxcpf.read('cpfCnpj'),
                    Storagerds.boxToken.read('token'),
                  );
                },
              )),
          const Divider(),
        ],
      ),
    );
  }

  Future<void> reloadList() async {
    try {
      await meusVeiculosController.loadVeiculos();
    } catch (e) {
      showErrorMessageSnackBar(e.toString());
    }
  }

  void confirmaExcluirVeiculoDialog(
      BuildContext context, String placa, String cpf, String token) {
    Widget cancelButton = TextButton(
      child: const Text("Cancelar"),
      onPressed: () {
        Get.back();
      },
    );

    Widget continueButton = TextButton(
      child: const Text("Confirmar"),
      onPressed: () async {
        meusVeiculosController.deleteVeiculo( placa, cpf, token);
        reloadList();
        showInfoSnackBar("Veiculo excluído com sucesso");
        Get.back();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Image.asset(
            "assets/notificationLargeIcon.png",
            height: 40,
            width: 40,
          ),
          const Text("Atenção"),
        ],
      ),
      content: Text("Você confirma a exclusão do veiculo de placa $placa?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showInfoSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  void showErrorMessageSnackBar(String message) {
    Get.snackbar(
      "Serviço indisponível",
      message,
      backgroundColor: errorColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
