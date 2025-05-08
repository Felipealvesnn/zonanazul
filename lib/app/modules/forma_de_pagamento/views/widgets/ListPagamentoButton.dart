import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/forma_de_pagamento_controller.dart';

class ListPagamentoButton extends GetView<FormaDePagamentoController> {
  const ListPagamentoButton({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FormaDePagamentoController());

    @override
    void onInit() {}

    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        onPressed: () {
          _selecionaVeiculoScaff(context);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "forma",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "placa button",
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void _selecionaVeiculoScaff(context) {
    controller.botaoFormaPagamento =
        controller.boxListPagamentoButton.read("boxListPagamentoButton");
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
                    //Get.toNamed(Routes.CADASTRO_VEICULO);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, shape: const CircleBorder(), backgroundColor: Colors.blue,
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
                                child: ListView(
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.credit_card),
                                            title: const Text("Cartao"),
                                            subtitle: const Text("Numeracao"),
                                            onTap: () {
                                              Get.back();
                                              //para validação na estacionarView
                                            },
                                          ),
                                          const Divider(color: Colors.black),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                    )
                  ],
                )),
          );
        });
  }
}
