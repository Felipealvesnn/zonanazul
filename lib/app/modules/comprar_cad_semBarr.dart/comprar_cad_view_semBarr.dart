import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slider_button/slider_button.dart';
import 'package:zona_azul/app/data/models/cad.dart';
import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/modules/comprar_cad/controllers/comprar_cad_controller.dart';
import 'package:zona_azul/app/modules/comprar_cad/views/comprar_cad_view.dart';
import 'package:zona_azul/app/modules/comprar_cad/views/listCartaoButton.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class ComprarCadViewSemBarr extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final CartaoCreditoController cartaoCreditoController =
      Get.find<CartaoCreditoController>();
  final ComprarCadController comprarCadController =
      Get.find<ComprarCadController>();

  ComprarCadViewSemBarr({super.key});

  @override
  Widget build(BuildContext context) {
    comprarCadController.pagando.value = false;
    if (homeController.listcad.isEmpty) {
      homeController.carregarCad();
    }

    Future<void> reloadList() async {
      homeController.carregarCad();

      Future.delayed(
        const Duration(seconds: 1),
        () {
          //  homeController.currentIndex.value = 0;
        },
      );
    }

    return PopScope(
      onPopInvoked: (didPop) {
        sair();
      },
      child: Scaffold(
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: reloadList,
          child: Obx(
            () => Center(
                child: homeController.listcad.isEmpty
                    ? const ShimmerLoadingList()
                    : ListView.builder(
                        itemCount: homeController.listcad.length,
                        itemBuilder: (context, index) {
                          Cad cads = homeController.listcad[index];
                          return Column(children: [
                            ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(cads.descricao.toString(),
                                      style: const TextStyle(fontSize: 18)),
                                  Text(
                                    "R\$ ${cads.valor.toString()}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios_rounded),
                              onTap: () {
                                confirmaPagamento(
                                  context,
                                  cads.valor!,
                                  cads.unidade!.toInt(),
                                );
                              },
                            ),
                            const Divider(color: Colors.black),
                          ]);
                        })),
          ),
        ),
      ),
    );
  }

  void confirmaPagamento(
      BuildContext context, double valorCadReais, int unidadeCadQtd) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      context: context,
      builder: (BuildContext bc) {
        return Card(
          margin: const EdgeInsets.only(top: 13, left: 4, right: 4),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Scaffold(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Center(
                                  child: Text(
                                "Comprar: $unidadeCadQtd CAD = por R\$ $valorCadReais ?",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                            ),
                            // modal q seleciona os cartoes
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: SizedBox(
                                height: 60,
                                width: 300,
                                child: ListCartaoButton(),
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                replacement: const CircularProgressIndicator(),
                                visible: !comprarCadController.pagando.value,
                                child: SliderButton(
                                  buttonColor: Get.theme.primaryColor,
                                  height: 60,
                                  width: 300,
                                  vibrationFlag: true,
                                  action: () async {
                                    // lê se já existe cartão selecionado
                                    final cartaoSelecionado = Storagerds
                                            .boxCartaoSelecionado
                                            .read<bool?>(
                                                'boxCartaoSelecionado') ??
                                        false;

                                    if (cartaoSelecionado) {
                                      // recupera o objeto do cartão
                                      final cartSelecionado =
                                          cartaoCreditoController
                                              .boxCartaoSelecionadoComprarCad
                                              .read<CartaoCreditoDebito>(
                                        'boxCartaoSelecionadoComprarCad',
                                      )!;

                                      // sinaliza que começou o pagamento
                                      comprarCadController.pagando.value = true;
                                      // limpa seleção
                                      Storagerds.boxCartaoSelecionado
                                          .write('boxCartaoSelecionado', false);

                                      // executa a chamada de pagamento (supondo que seja async)
                                      await homeController.comprarCad(
                                        unidadeCadQtd,
                                        cartSelecionado.numero.toString(),
                                        cartSelecionado.tipoCartao.toString(),
                                        valorCadReais.toDouble(),
                                      );

                                      // retorna true para manter o slider no fim ou fazer o que o pacote espera
                                      return true;
                                    } else {
                                      // mostra snackbar de erro
                                      Get.snackbar(
                                        "Não foi possível concluir",
                                        "Selecione uma forma de pagamento",
                                        colorText: Colors.white,
                                        backgroundColor: errorColor,
                                        duration: const Duration(seconds: 3),
                                        snackPosition: SnackPosition.TOP,
                                      );
                                      // retorna false (ou null) para que o slider volte ao início
                                      return false;
                                    }
                                  },
                                  alignLabel: const Alignment(0.2, 0),
                                  label: const Text(
                                    "Deslize para confirmar",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.double_arrow_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              )
            ],
          )),
        );
      },
    );
  }
}

class ShimmerLoadingList extends StatelessWidget {
  const ShimmerLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        itemCount: 20,
      ),
    );
  }
}
