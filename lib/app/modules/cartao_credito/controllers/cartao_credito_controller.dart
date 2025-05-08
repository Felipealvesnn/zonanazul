import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';
import 'package:zona_azul/app/data/repository/cartaoCreditoDebito_repository.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class CartaoCreditoController extends GetxController {
  RxBool loading = false.obs;
  RxBool deletando = false.obs;

  CartaoCreditoDebitoRepository cartaoCreditoDebitoRepository =
      CartaoCreditoDebitoRepository();

  String? retornoDaApi;

  RxList<CartaoCreditoDebito> cartaoCredito = <CartaoCreditoDebito>[].obs;
  RxList<CartaoCreditoDebito> cartaoDebito = <CartaoCreditoDebito>[].obs;
  RxList<CartaoCreditoDebito> listaCartoesComprarCredito =
      <CartaoCreditoDebito>[].obs;
  CartaoCreditoDebito conversorCredito = CartaoCreditoDebito();
  CartaoCreditoDebito conversorDebito = CartaoCreditoDebito();

  final boxCartaoSelecionadoComprarCad =
      GetStorage('boxCartaoSelecionadoComprarCad');

  RxString cartaoSelecionadoComprarCad = "Selecione um Cartão".obs;
  RxString cartaoConfirmado = "".obs;

  final boxListCartoes = GetStorage('boxListCartoes');
  final boxListCartoesCredito = GetStorage('boxListCartoesCredito');
  final boxListCartoesDebito = GetStorage('boxListCartoesDebito');
  final boxlistaCartoesComprarCredito =
      GetStorage('boxlistaCartoesComprarCredito');

  Future<void> loadCartoes() async {
    try {
      var cpfCnpj = Storagerds.boxcpf.read('cpfCnpj');
      var token = Storagerds.boxToken.read('token');

      List<CartaoCreditoDebito> listCartaoCreditoDebito =
          await cartaoCreditoDebitoRepository.listarCartoesCreditoDebito(
              cpfCnpj, token);

      if (listCartaoCreditoDebito.isNotEmpty) {
        boxListCartoes.write('boxListCartoes', listCartaoCreditoDebito);

        boxListCartoesCredito.write(
          'boxListCartoesCredito',
          listCartaoCreditoDebito
              .where((item) => item.tipoCartao == "1")
              .toList(),
        );
        cartaoCredito.value =
            boxListCartoesCredito.read('boxListCartoesCredito');

        listaCartoesComprarCredito.value = listCartaoCreditoDebito;
        boxlistaCartoesComprarCredito.write(
            'boxlistaCartoesComprarCredito', listaCartoesComprarCredito);
      } else {
        print("A lista de cartões veio vazia do endpoint");
      }


    } catch (e) {
      print("loadCartoes(): $e");
    }
  }

  Future<void> cadastrarCartao(
    String nomeTitular,
    String numero,
    String anoExpiracao,
    String mesExpiracao,
    int codSeguranca,
    String tipoCartao,
    String cpfcnpj,
    String token,
  ) async {
    try {
      final cartaoCadastrado = await cartaoCreditoDebitoRepository.cadastrar(
        nomeTitular,
        numero,
        anoExpiracao,
        mesExpiracao,
        codSeguranca,
        tipoCartao,
        cpfcnpj,
        token,
      );

      if (cartaoCadastrado != null) {
        FuncoesParaAjudar.exibirSucessoSnackBar();
        loadCartoes();
        loading.value = false;
        await Future.delayed(Duration(seconds: 3));
        Get.back();
      }
    } catch (err) {
      FuncoesParaAjudar.exibirErroSnackBar(err.toString());
      loading.value = false;
    }
  }

//
//
//
//

//
//
//
//
//
//
//

  deletarCartao(String numero, String cpf, String token, context) async {
    try {
      await cartaoCreditoDebitoRepository
          .deletarCard(numero, cpf, token)
          .then((cartaoDeletado) {
        if (cartaoDeletado != null) {
          loadCartoes();

          const snackBar = SnackBar(
            content: Text("Cartão excluido com sucesso"),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          loadCartoes();
        }
      }).catchError((err) {
        loading.value = false;
        // Get.defaultDialog(title: "Falha na validação", content: Text("Err: ${err}"));
        //Get.defaultDialog(title: "Falha na validação",content: Text("Por favor verifique login e senha."));
        Get.snackbar("Falha na validação", "${err.toString()}",
            colorText: Colors.white,
            backgroundColor: errorColor,
            duration: Duration(seconds: 10),
            snackPosition: SnackPosition.TOP);
      });
    } catch (e) {
      Get.snackbar("error", "${e.toString()}",
          colorText: Colors.white,
          backgroundColor: errorColor,
          duration: Duration(seconds: 10),
          snackPosition: SnackPosition.TOP);
      ;
    }
  }

  void onInit() async {
    super.onInit();
    await loadCartoes();
  }

  @override
  void onClose() {}
}
