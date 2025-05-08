import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/controllers/cadastro_veiculo_controller.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/meus_veiculos/controllers/meus_veiculos_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class ListCarButton extends StatelessWidget {
  ListCarButton({Key? key}) : super(key: key);
  HomeController homeController = HomeController();
  EstacionarController estacionarController = EstacionarController();
  MeusVeiculosController meusVeiculosController =
      Get.find<MeusVeiculosController>();
  VeiculoController veiculoController = VeiculoController();

  @override
  Widget build(BuildContext context) {
    homeController.placaButton.value =
        Storagerds.boxBotaoCarro.read('placaBotao');
    homeController.marcaButton.value =
        Storagerds.boxBotaoCarro.read('marcaBotao');

    @override
    void onInit() {}

    return Obx(() => TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        onPressed: () {
          var carros = Storagerds.boxListVeic.read('boxListVeic');

          if (carros != null) {
            meusVeiculosController.loadVeiculos();
            meusVeiculosController.listveic.value =
                Storagerds.boxListVeic.read('boxListVeic');
          } else {
            meusVeiculosController.loadVeiculos();
          }

          _selecionaVeiculoScaff(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image.asset("assets/veiculos/celta.png"),
            const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.drive_eta,
                  size: 50,
                )),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "${homeController.marcaButton}",
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${homeController.placaButton}",
                    style: const TextStyle(
                      fontSize: 27,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_drop_down_sharp,
              color: Colors.black,
            )
          ],
        )));
  }

  void _selecionaVeiculoScaff(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext bc) {
          return Card(
            margin: const EdgeInsets.only(top: 13, left: 4, right: 4),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: Scaffold(
                floatingActionButton: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(Routes.CADASTRO_VEICULO);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, shape: const CircleBorder(),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(20), // <-- Splash color
                  ),
                  child: const Icon(Icons.add),
                ),
                body: ListView(
                  shrinkWrap: false,
                  children: [
                    Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0))),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: Get.height * 0.5,
                              width: Get.width * 0.5,
                              child: meusVeiculosController
                                      .listveic.value.isEmpty
                                  ? ListView(
                                      children: const [
                                        ListTile(
                                          title: Center(
                                            child: Text(
                                                "Nenhum veiculo encontrado"),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Obx(() => ListView.builder(
                                      itemCount: meusVeiculosController
                                          .listveic.length,
                                      itemBuilder: (context, index) {
                                        Veiculo veiculos =
                                            meusVeiculosController
                                                .listveic[index];

                                        return Container(
                                          child: Column(
                                            children: [
                                              ListTile(
                                                trailing: IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    //Get.toNamed(Routes.EDITAR_CADASTRO_VEICULO);
                                                    veiculoController
                                                            .placaTextController =
                                                        veiculos.placa
                                                            .toString();

                                                    Get.off(EditarVeiculoView(
                                                      placa: veiculos.placa,
                                                      marca: veiculos.marca,
                                                      tipoVeiculo: Storagerds
                                                          .boxtipoVeic
                                                          .read('tipoVeic'),
                                                      cpf: veiculoController
                                                          .boxcpf
                                                          .read('cpfCnpj'),
                                                      token: veiculoController
                                                          .boxToken
                                                          .read('token'),
                                                    ));
                                                  },
                                                ),
                                                leading: const Icon(
                                                  Icons.drive_eta,
                                                  size: 50,
                                                ),
                                                title:
                                                    Text("${veiculos.placa}"),
                                                subtitle:
                                                    Text("${veiculos.marca}"),
                                                onTap: () => {
                                                  homeController
                                                          .placaButton.value =
                                                      veiculos.placa.toString(),
                                                  print(homeController
                                                      .placaButton.value),
                                                  homeController
                                                          .marcaButton.value =
                                                      veiculos.marca.toString(),
                                                  print(homeController
                                                      .marcaButton.value),

                                                  Storagerds.boxBotaoCarro
                                                      .write(
                                                          'placaBotao',
                                                          veiculos.placa
                                                              .toString()),
                                                  Storagerds.boxBotaoCarro
                                                      .write(
                                                          'marcaBotao',
                                                          veiculos.marca
                                                              .toString()),
                                                  Storagerds
                                                      .boxcamposValidadosEstacionar
                                                      .write(
                                                          'placa',
                                                          veiculos.placa
                                                              .toString()),

                                                  Get.back(),
                                                  //para validação na estacionarView
                                                },
                                              ),
                                              const Divider(
                                                  color: Colors.black),
                                            ],
                                          ),
                                        );
                                      })),
                            ),
                          ]),
                    )
                  ],
                )),
          );
        });
  }
}
