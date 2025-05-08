import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zona_azul/app/modules/pagamento/controllers/pagamento_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';

import '../controllers/cartao_debito_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartaoDebitoView extends GetView<CartaoDebitoController> {
  PagamentoController pagamentoController = PagamentoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Escolha o seu banco'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text("BANCO DO BRASIL"),
              leading: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('assets/bancos/bancoDoBrasil.png'),
              ),
              onTap: () {
                Get.toNamed(Routes.CADASTRO_CARTAO_DEBITO);
              },
            ),
            Divider(color: Colors.black),
            ListTile(
                title: Text("CAIXA"),
                leading: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset('assets/bancos/caixa.png')),
                onTap: () {
                  Get.toNamed(Routes.CADASTRO_CARTAO_DEBITO);
                }),
            Divider(color: Colors.black),
            ListTile(
                title: Text("BANCO INTER"),
                leading: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset('assets/bancos/inter.png')),
                onTap: () {
                  Get.toNamed(Routes.CADASTRO_CARTAO_DEBITO);
                }),
            Divider(color: Colors.black),
            ListTile(
                title: Text("ITAU"),
                leading: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset('assets/bancos/itau.png')),
                onTap: () {
                  Get.toNamed(Routes.CADASTRO_CARTAO_DEBITO);
                }),
            Divider(color: Colors.black),
            ListTile(
                title: Text("NUBANK"),
                leading: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset('assets/bancos/nubank.png')),
                onTap: () {
                  Get.toNamed(Routes.CADASTRO_CARTAO_DEBITO);
                }),
            Divider(color: Colors.black),
            ListTile(
                title: Text("SANTANDER"),
                leading: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset('assets/bancos/santander.png')),
                onTap: () {
                  Get.toNamed(Routes.CADASTRO_CARTAO_DEBITO);
                }),
            Divider(color: Colors.black),
            ListTile(
                title: Text("BRADESCO"),
                leading: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset('assets/bancos/bradesco.png')),
                onTap: () {
                  Get.toNamed(Routes.CADASTRO_CARTAO_DEBITO);
                }),
            Divider(color: Colors.black),
          ],
        ));
  }
}
