import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/data/repository/cartaoCreditoDebito_repository.dart';
import 'package:zona_azul/app/modules/cartao_credito/controllers/cartao_credito_controller.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class PagamentoController extends GetxController {
  CartaoCreditoDebitoRepository cartaoCreditoDebitoRepository =
      CartaoCreditoDebitoRepository();
  CartaoCreditoController cartaoCreditoController = CartaoCreditoController();

  // Controladores locais
  Rx<GlobalKey<FormState>> chaveFormularioCartaoCredito =
      GlobalKey<FormState>().obs;

  Rx<TextEditingController> nomeDoTitularEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> numeroCartaoEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> mesValidadeEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> anoValidadeEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> codSeguranEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> cpfCnpjEditingController =
      TextEditingController().obs;

  //final boxcartaoCreditoDebito = GetStorage('cartaoCreditoDebito');
  final boxcpf = GetStorage('cpfCnpj');
  final boxToken = GetStorage('token');
  RxBool loading = false.obs;
  RxBool isSelectedCredito = false.obs;
  RxBool isSelectedDebito = false.obs;

  @override
  void onInit() {
//kkk
    super.onInit();
    cpfCnpjEditingController.value =
        TextEditingController(text: Storagerds.boxcpf.read('cpfCnpj'));
    print("PagamentoController inciadio");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    print("PagamentoController fechado");
  }

  Future<void> continuar() async {
    loading.value = true;
    int? codSeg = int.tryParse(codSeguranEditingController.value.text);
   
    await cartaoCreditoController.cadastrarCartao(
      nomeDoTitularEditingController.value.text,
      numeroCartaoEditingController.value.text,
      anoValidadeEditingController.value.text,
      mesValidadeEditingController.value.text,
      codSeg!,
      "1",
      cpfCnpjEditingController.value.text,
      Storagerds.boxToken.read("token"),
    );
    loading.value = false;
  }
}
