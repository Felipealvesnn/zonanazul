import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';

import '../controllers/pagamento_controller.dart';

class PagamentoView extends GetView<PagamentoController> {
  CartaoCreditoController cartaoCreditoController = CartaoCreditoController();
  CartaoCreditoDebito listaConversor = CartaoCreditoDebito();

  PagamentoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Formas de Pagamento'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            const Divider(
              color: Colors.grey,
              height: 5,
            ),
            Obx(
              () => ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text("Cartão de Crédito"),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                dense: false,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
                tileColor: controller.isSelectedCredito.value
                    ? Get.theme.primaryColor
                    : null,
                onTap: () {
                  if (cartaoCreditoController.cartaoCredito.value != null ||
                      cartaoCreditoController.cartaoCredito.value.isNotEmpty) {
                    Get.toNamed(Routes.CARTAO_CREDITO_LISTAGEM);
                  } else {
                    cartaoCreditoController.loadCartoes();
                    Get.toNamed(Routes.CARTAO_CREDITO_LISTAGEM);
                  }
                },
                //hoverColor: Colors.red,
              ),
            ),
            const Divider(
              color: Colors.grey,
              height: 5,
            ),
            Obx(
              () => ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text("Cartão de Débito"),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                dense: false,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                tileColor: controller.isSelectedDebito.value
                    ? Get.theme.primaryColor
                    : null,
                onTap: () {
                  if (cartaoCreditoController.cartaoDebito.isNotEmpty) {
                    Get.toNamed(Routes.CARTAO_DEBITO_LISTAGEM);
                  } else {
                    //cartaoCreditoController.loadCartoes();
                    Get.toNamed(Routes.CARTAO_DEBITO_LISTAGEM);
                  }
                },
              ),
            ),
            const Divider(
              color: Colors.grey,
              height: 5,
            ),
          ],
        ));
  }
}
