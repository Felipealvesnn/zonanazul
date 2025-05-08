import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

// ignore: must_be_immutable
class FormaDePagamentoCadView extends GetView {
  double? valorCadReais;
  int? unidadeCadQtd;

  FormaDePagamentoCadView({super.key, this.valorCadReais, this.unidadeCadQtd});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Forma de pagamento'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
                child: Text(
                    "Comprar: $unidadeCadQtd CAD = por R\$ $valorCadReais ?")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Container(
                    color: Colors.white,
                    child: const ListTile(
                      leading: Icon(
                        Icons.credit_card,
                        color: Colors.black,
                      ),
                      title: Text("Cartão de crédito"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Container(
                    color: Colors.white,
                    child: const ListTile(
                      leading: Icon(Icons.credit_card, color: Colors.black),
                      title: Text("Cartão de débito"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
