import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/pagamento/controllers/pagamento_controller.dart';
import 'package:zona_azul/app/data/global/constants.dart';

import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class CartaoCreditoListagemView extends GetView<CartaoCreditoController> {
  //
  PagamentoController pagamentoController = PagamentoController();
  HomeController homeController = Get.find<HomeController>();
  EstacionarController estacionarController = Get.find<EstacionarController>();

  CartaoCreditoListagemView({super.key});

  Function? relod(context) {
    controller.loadCartoes();
    Navigator.pop(context);
    return null;
  }

  start() {
   // controller.loadCartoes();

    controller.listaCartoesComprarCredito.value =
        controller.boxListCartoesCredito.read('boxListCartoesCredito')??[];
  }

  @override
  Widget build(BuildContext context) {
    try {
      start();
    } catch (error) {}

    return Scaffold(
        appBar: AppBar(
          title: const Text('Cartões de crédito'),
          centerTitle: true,
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            //Get.back();
            Get.toNamed(Routes.CARTAO_CREDITO);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, shape: const CircleBorder(), backgroundColor: Colors.blue,
            padding: const EdgeInsets.all(20), // <-- Splash color
          ),
          child: const Icon(Icons.add),
        ),
        body: RefreshIndicator(
            onRefresh: reloadList,
            child: controller.listaCartoesComprarCredito.isEmpty
                ? ListView(
                    children: const [
                      ListTile(
                        title: Center(
                          child: Text("Nenhum Cartão encontrado"),
                        ),
                      ),
                    ],
                  )
                : Obx(() => ListView.builder(
                    itemCount: controller.listaCartoesComprarCredito.length,
                    itemBuilder: (context, index) {
                      CartaoCreditoDebito cartoes =
                          controller.cartaoCredito[index];

                      return Container(
                        child: Column(
                          children: [
                            ListTile(
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  confirmacaoDialog(
                                      context,
                                      cartoes.ultimosDigitos,
                                      cartoes.numero,
                                      cartoes.cpfcnpj,
                                      Storagerds.boxToken.read('token'));
                                },
                              ),
                              leading: const Icon(Icons.credit_card),
                              title: Text(
                                  "***.${cartoes.ultimosDigitos.toString()}"),
                              subtitle: Text(cartoes.bandeira.toString()),
                             // onTap: () => Get.back(),
                            ),
                            const Divider(color: Colors.black),
                          ],
                        ),
                      );
                    }))));
  }

  confirmacaoDialog(BuildContext context, ultimosdigitos, numero, cpf, token) {
    // set up the buttons
    Widget cancelarButton = TextButton(
      child: const Text("Cancelar"),
      onPressed: () {
        Get.back();
      },
    );
    Widget continuarButton = TextButton(
      child: const Text("Confirmar"),
      onPressed: () async {
        controller.deletarCartao(numero, cpf, token, context);
        relod(context);
      },
    );
    // set up the AlertDialog
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
      content: Text("Você confirma a exclusão do cartão ***$ultimosdigitos?"),
      actions: [
        cancelarButton,
        continuarButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> reloadList() async {
    try {
      controller.loadCartoes();
    } on Exception catch (e) {
      Get.snackbar("Serviço indisponivel", e.toString(),
          backgroundColor: errorColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 3));
    }
  }
}
