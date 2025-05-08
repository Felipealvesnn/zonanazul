import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:slider_button/slider_button.dart';
import 'package:zona_azul/app/data/models/cad.dart';
import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/modules/comprar_cad/views/forma_de_pagamento_cad_view.dart';
import 'package:zona_azul/app/modules/comprar_cad/views/listCartaoButton.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/home/views/widgets/ListCarButton.dart';
import 'package:zona_azul/app/data/global/constants.dart';

import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

import '../controllers/comprar_cad_controller.dart';

/* {
    "cadID": "1", string
    "descricao": "1 cartão", string
    "tempo": 1,              int
    "valor": 2,            double
    "unidade": 1         int
  },


valor R$  double
unidade: CAD quqntidade  int
 */
sair() {
  Get.offAllNamed(Routes.HOME);
}

class ComprarCadView extends GetView<ComprarCadController> {
  HomeController homeController = HomeController();
  CartaoCreditoController cartaoCreditoController = CartaoCreditoController();

  ComprarCadView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.pagando.value = false;
    homeController.carregarCad;
    var observer = Storagerds.boxListCad.read("boxListCad");
    if (Storagerds.boxListCad.read("boxListCad") != null) {
      homeController.listcad.value = Storagerds.boxListCad.read("boxListCad");
    } /* else if (!homeController.boxListCad.read("boxListCad").isBlank) {
      homeController.listcad.value =
          homeController.boxListCad.read("boxListCad"); */
    else {}

    cartaoCreditoController.loadCartoes();

    Future.delayed(
        const Duration(seconds: 2),
        () => cartaoCreditoController.cartaoCredito.value =
            cartaoCreditoController.boxListCartoesCredito
                .read("boxListCartoesCredito"));

    Future<void> reloadList() async {
      homeController.carregarCad();
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();

        Get.toNamed(Routes.COMPRAR_CAD);
      });
    }

    return WillPopScope(
      onWillPop: () async {
        sair();

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Comprar créditos'),
          centerTitle: true,
        ),
        body: Container(
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: reloadList,
            child: Center(
              child: homeController.listcad.isEmpty
                  ? ListView(
                      children: const [
                        ListTile(
                          title: Center(
                            child: Text(
                                "Não foi possivel receber as informações de preço"),
                          ),
                        ),
                        ListTile(
                          title: Center(
                            child: Text(
                                "Verifique sua conexão e faça login novamente."),
                          ),
                        ),
                      ],
                    )
                  : Obx(() => ListView.builder(
                      itemCount: homeController.listcad.length,
                      itemBuilder: (context, index) {
                        Cad cads = homeController.listcad[index];
                        return Column(children: [
                          ListTile(
                            //leading: Text("R\$"),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            //subtitle: Text("R\$ ${cads.valor.toString()}"),
                            trailing:
                                const Icon(Icons.arrow_forward_ios_rounded),
                            //dense: true,
                            onTap: () {
                              /*  Get.to(FormaDePagamentoCadView(
                                unidadeCadQtd: cads.unidade,
                                valorCadReais: cads.valor,
                              )); */

                              confirmaPagamento(
                                  context, cads.valor!, cads.unidade!.toInt());
                            },
                          ),
                          const Divider(color: Colors.black),
                        ]);
                      })),
            ),
          ),
        ),
      ),
    );
  }

  void confirmaPagamento(context, double valorCadReais, int unidadeCadQtd) {
    RxBool confirmado = false.obs;

    Color backGroundSlider = errorColor;
    Color backGroundSliderEnd = const Color.fromARGB(255, 103, 199, 106);
    cartaoCreditoController.loadCartoes();

    Future.delayed(
        const Duration(seconds: 1),
        () => cartaoCreditoController.cartaoCredito.value =
            cartaoCreditoController.boxListCartoesCredito
                .read("boxListCartoesCredito"));

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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: SizedBox(
                                    height: 60,
                                    width: 300,
                                    child: ListCartaoButton()),
                              ),
                              /////////////////////////////////////////////////////////////////////////////////
                              Obx(
                                () => Visibility(
                                  visible: !controller.pagando.value,
                                  child: SliderButton(
                                    buttonColor: Get.theme.primaryColor,
                                    height: 60,
                                    width: 300,
                                    vibrationFlag: true,
                                    action: () async {
                                      // lê se já existe cartão selecionado (garanta o tipo genérico aqui)
                                      final cartaoSelecionado = Storagerds
                                              .boxCartaoSelecionado
                                              .read<bool>(
                                                  'boxCartaoSelecionado') ??
                                          false;

                                      if (cartaoSelecionado) {
                                        // recupera o objeto do cartão
                                        final cartSelecionado =
                                            cartaoCreditoController
                                                .boxCartaoSelecionadoComprarCad
                                                .read<CartaoCreditoDebito>(
                                                    'boxCartaoSelecionadoComprarCad')!;

                                        // sinaliza confirmação
                                        confirmado.value = true;
                                        debugPrint("confirmado: $confirmado");

                                        // sinaliza que iniciou o pagamento
                                        controller.pagando.value = true;

                                        // limpa seleção
                                        Storagerds.boxCartaoSelecionado.write(
                                            'boxCartaoSelecionado', false);

                                        // executa o pagamento (aguarde se for Future)
                                        await homeController.comprarCad(
                                          unidadeCadQtd,
                                          cartSelecionado.numero.toString(),
                                          cartSelecionado.tipoCartao.toString(),
                                          valorCadReais.toDouble(),
                                        );

                                        // retorna true para indicar sucesso (slider finaliza)
                                        return true;
                                      } else {
                                        // feedback de erro
                                        Get.snackbar(
                                          "Não foi possível concluir",
                                          "Selecione uma forma de pagamento",
                                          colorText: Colors.white,
                                          backgroundColor: errorColor,
                                          duration: const Duration(seconds: 3),
                                          snackPosition: SnackPosition.TOP,
                                        );
                                        // retorna false para resetar o slider
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

                              //-------------------
                              Obx(() => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Visibility(
                                        visible: controller.pagando.value,
                                        child:
                                            const CircularProgressIndicator()),
                                  )),
                              /*  Obx(
                  () => Visibility(
                      visible: estacionarController.loading.value,
                      child: CircularProgressIndicator()),
                ),
 */

                              ////////////////////////////////////////////////////////////////////////////////////////
                            ],
                          ),
                        ),
                      ]),
                )
              ],
            )),
          );
        });
  }

  void _selecionaFormaPagamento(context) {
    cartaoCreditoController.loadCartoes();

    Future.delayed(
        const Duration(seconds: 1),
        () => cartaoCreditoController.cartaoCredito.value =
            cartaoCreditoController.boxListCartoesCredito
                .read("boxListCartoesCredito"));

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
                              child: cartaoCreditoController
                                      .cartaoCredito.value.isEmpty
                                  ? ListView(
                                      children: const [
                                        ListTile(
                                          title: Center(
                                            child: Text(
                                                "Nenhum meio de pagamento encontrado"),
                                          ),
                                        ),
                                        ListTile(
                                          title: Center(
                                            child: Text(
                                                "Verifique sua conexão e tente novamente"),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Obx(() => ListView.builder(
                                      itemCount: cartaoCreditoController
                                          .cartaoCredito.length,
                                      itemBuilder: (context, index) {
                                        CartaoCreditoDebito cartoes =
                                            cartaoCreditoController
                                                .cartaoCredito[index];

                                        return Container(
                                          child: Column(
                                            children: [
                                              ListTile(
                                                trailing: IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {},
                                                ),
                                                leading: Image.asset(
                                                    "assets/icons/car.png"),
                                                title: const Text("placa"),
                                                subtitle: const Text(
                                                    "veiculos.marca"),
                                                onTap: () => {
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

  _PagarButtonStyle() {
    //estilo do botao cadastrar
    return ElevatedButton.styleFrom(
      //primary: Color.fromARGB(255, 129, 212, 250),
      backgroundColor: const Color(0xFFffcc43),
      //onPrimary: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      padding: const EdgeInsets.all(12),
    );
  }
}
