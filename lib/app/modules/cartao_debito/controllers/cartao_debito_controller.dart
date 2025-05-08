import 'package:get/get.dart';
import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/data/repository/cartaoCreditoDebito_repository.dart';
import 'package:zona_azul/app/modules/pagamento/controllers/pagamento_controller.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class CartaoDebitoController extends GetxController {
  PagamentoController pagamentoController = PagamentoController();
  RxList<CartaoCreditoDebito> cartaoDebito = <CartaoCreditoDebito>[].obs;
  CartaoCreditoDebitoRepository cartaoCreditoDebitoRepository =
      CartaoCreditoDebitoRepository();

  Future<void> loadCartoes() async {
    try {
      var cpfCnpj = Storagerds.boxcpf.read('cpfCnpj');
      var token = Storagerds.boxToken.read('token');

      List<CartaoCreditoDebito> listCartaoCreditoDebito =
          await cartaoCreditoDebitoRepository.listarCartoesCreditoDebito(
              cpfCnpj, token);

      if (listCartaoCreditoDebito.isNotEmpty) {
        await Storagerds.boxListCartoesDebito.write(
          'boxListCartoesDebito',
          listCartaoCreditoDebito
              .where((item) => item.tipoCartao == "DEBITO")
              .toList(),
        );
        cartaoDebito.value = listCartaoCreditoDebito
            .where((item) => item.tipoCartao == "DEBITO")
            .toList();
      } else {
        print("A lista de cartões veio vazia do endpoint");
      }

      print(
          "reloadlistcartoes: ${cartaoDebito.isNotEmpty ? cartaoDebito[0].numero : ''}");
    } catch (e) {
      print("loadCartoes(): $e");
    }
  }

  final count = 0.obs;
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
  void increment() => count.value++;
}
