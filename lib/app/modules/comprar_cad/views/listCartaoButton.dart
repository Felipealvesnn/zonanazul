import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/modules/comprar_cad/controllers/comprar_cad_controller.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class ListCartaoButton extends StatelessWidget {
  ListCartaoButton({Key? key}) : super(key: key);

  final EstacionarController estacionarController = Get.find<EstacionarController>();
  final CartaoCreditoController cartaoCreditoController = Get.find<CartaoCreditoController>();

  final boxRetornoDaApiRequisicao = GetStorage('boxRetornoDaApiRequisicao');

  @override
  Widget build(BuildContext context) {
    cartaoCreditoController.boxCartaoSelecionadoComprarCad
        .write('boxCartaoSelecionadoComprarCad', 'Selecione um Cartão');

    cartaoCreditoController.cartaoSelecionadoComprarCad.value = 'Selecione um Cartão';
       

   // cartaoCreditoController.listaCartoesComprarCredito.value =
       // cartaoCreditoController.boxListCartoesCredito.read("boxListCartoesCredito");

    return Obx(() => TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
      onPressed: () => _selecionaRegra(context),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  cartaoCreditoController.cartaoSelecionadoComprarCad.value ==
                          "Selecione um Cartão"
                      ? cartaoCreditoController.cartaoSelecionadoComprarCad.value
                      : "****.${cartaoCreditoController.cartaoConfirmado.value}",
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
      ),
    ));
  }

  void _selecionaRegra(context) {
    Future<void> reloadList() async {
      cartaoCreditoController.loadCartoes();
      Get.back();
      _selecionaRegra(context);
    }

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          shrinkWrap: false,
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: Get.height * 0.5,
                      width: Get.width * 0.5,
                      child: cartaoCreditoController
                              .listaCartoesComprarCredito.isEmpty
                          ? RefreshIndicator(
                              onRefresh: reloadList,
                              child: ListView(
                                children: const [
                                  ListTile(
                                    title: Center(
                                      child: Text(
                                         'Cartões nao carredos'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Obx(() => ListView.builder(
                              itemCount: cartaoCreditoController.listaCartoesComprarCredito.length,
                              itemBuilder: (context, index) {
                                CartaoCreditoDebito carts =
                                    cartaoCreditoController.listaCartoesComprarCredito[index];
                                return Container(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text("***.${carts.ultimosDigitos.toString()}"),
                                        subtitle: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${carts.bandeira}"),
                                            Text("${carts.tipoCartao}"),
                                          ],
                                        ),
                                        onTap: () {
                                          cartaoCreditoController.boxCartaoSelecionadoComprarCad
                                              .write('boxCartaoSelecionadoComprarCad', carts);
                                          cartaoCreditoController.cartaoSelecionadoComprarCad.value =
                                              carts.ultimosDigitos.toString();
                                          cartaoCreditoController.cartaoConfirmado.value =
                                              carts.ultimosDigitos.toString();
                                            Storagerds.boxCartaoSelecionado.write('boxCartaoSelecionado', true);
                                          Get.back();
                                        },
                                      ),
                                      const Divider(color: Colors.black),
                                    ],
                                  ),
                                );
                              },
                            )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
