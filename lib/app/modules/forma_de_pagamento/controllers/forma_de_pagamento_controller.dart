import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FormaDePagamentoController extends GetxController {
  //TODO: Implement FormaDePagamentoController

  final boxListPagamentoButton = GetStorage('boxListPagamentoButton');

  RxString botaoFormaPagamento = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
