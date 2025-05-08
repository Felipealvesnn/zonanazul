import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/models/regra_estacionamento.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class ListRegra extends StatelessWidget {
  //ListRegra({Key? key}) : super(key: key);

  EstacionarController estacionarController = Get.find<EstacionarController>();

  final boxCamposValidadosEstacionar = GetStorage('CamposValidadosEstacionar');

  ListRegra({super.key});

  @override
  Widget build(BuildContext context) {
    estacionarController.regraButton.value =
         Storagerds.boxBotaoRegra.read('descricaoBotao');

    return Obx(() => TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        onPressed: () {
          estacionarController.loadRegras(Storagerds.boxCustomRadioCartoesValue
              .read('boxCustomRadioCartoesValue'));
          Future.delayed(
              const Duration(seconds: 1), () => _selecionaRegra(context));
        },
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image.asset("assets/veiculos/celta.png"),
            /*  Padding(
                padding: EdgeInsets.only(left: 10),
                child: Image.asset("assets/icons/car.png")), */
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${estacionarController.regraButton}",
                    style: const TextStyle(fontSize: 25, color: Colors.black),
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

  void _selecionaRegra(context) {
    Future<void> reloadList() async {
      print("press");
      estacionarController.loadRegras(Storagerds.boxCustomRadioCartoesValue
          .read('boxCustomRadioCartoesValue'));
      Get.back();
      _selecionaRegra(context);
    }

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            height: 300,
            child: estacionarController.listRegras.isEmpty
                ? RefreshIndicator(
                    onRefresh: reloadList,
                    child: ListView(
                      children: const [
                        ListTile(
                          title: Center(
                            child: Text("Não foi possivel receber as regras"),
                          ),
                        ),
                        ListTile(
                          title: Center(
                            child:
                                Text("Verifique sua conexão e tente novamente"),
                          ),
                        ),
                      ],
                    ),
                  )
                : Obx(() => ListView.builder(
                    itemCount: estacionarController.listRegras.length,
                    itemBuilder: (context, index) {
                      RegraEstacionamento regras =
                          estacionarController.listRegras[index];

                      return Column(
                        children: [
                          ListTile(
                              title: Text("${regras.descricao}"),
                              subtitle: null,
                              onTap: () => {
                                    estacionarController.regraButton.value =
                                        regras.descricao.toString(),
                                    print(
                                        estacionarController.regraButton.value),
                                    Storagerds.boxBotaoRegra.write(
                                        'descricaoBotao',
                                        regras.descricao.toString()),
                                    boxCamposValidadosEstacionar.write(
                                        'regraEstacionamendoID',
                                        regras.regraEstacionamentoID),
                                    Get.back()
                                  }),
                          const Divider(color: Colors.black),
                        ],
                      );
                    })),
          );
        });
  }
}
