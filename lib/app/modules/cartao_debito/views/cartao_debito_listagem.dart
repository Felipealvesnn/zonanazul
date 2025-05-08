import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/modules/cartao_debito/controllers/cartao_debito_controller.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/pagamento/controllers/pagamento_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';

class CartaoDebitoListagemView extends GetView<CartaoDebitoController> {
  PagamentoController pagamentoController = PagamentoController();
  HomeController homeController = HomeController();
  EstacionarController estacionarController = EstacionarController();
  CartaoDebitoController cartaoDebitoController =
      Get.find<CartaoDebitoController>();

  CartaoDebitoListagemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartões de Débito'),
        centerTitle: true,
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          //Get.back();
          // Get.toNamed(Routes.CARTAO_DEBITO);
          showDialog(
              context: context,
              builder: (BuildContext) {
                return AlertDialog(
                  content: SizedBox(
                    height: Get.size.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("Em breve",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Image.asset("assets/icons/aviso.png")
                      ],
                    ),
                  ),
                );
              });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, shape: const CircleBorder(),
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.all(20), // <-- Splash color
        ),
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () => Visibility(
          replacement: ListView(
            children: const [
              ListTile(
                title: Center(
                  child: Text("Nenhum Cartão encontrado"),
                ),
              ),
            ],
          ),
          visible: cartaoDebitoController.cartaoDebito.isNotEmpty,
          child: ListView(
            shrinkWrap: false,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: Get.height * 0.5,
                      width: Get.width * 0.5,
                      child: Obx(() => ListView.builder(
                          itemCount: cartaoDebitoController.cartaoDebito.length,
                          itemBuilder: (context, index) {
                            CartaoCreditoDebito cartoes =
                                cartaoDebitoController.cartaoDebito[index];

                            return Container(
                              child: Column(
                                children: [
                                  ListTile(
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {},
                                    ),
                                    leading: const Icon(Icons.credit_card),
                                    title: Text(
                                        "***.${cartoes.ultimosDigitos.toString()}"),
                                    subtitle: Text(cartoes.bandeira.toString()),
                                    onTap: () => Get.back(),
                                  ),
                                  const Divider(color: Colors.black),
                                ],
                              ),
                            );
                          })),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
