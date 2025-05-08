import 'dart:convert';

import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/data/provider/cartaoCreditoDebito_provider.dart';
import 'package:zona_azul/app/data/provider/veiculo_provider.dart';

class CartaoCreditoDebitoRepository {
  final CartaoCreditoDebitoProvider cartaoCreditoDebitoProvider =
      CartaoCreditoDebitoProvider();

  Future<CartaoCreditoDebito> cadastrar(
      String nomeTitular,
      String numero,
      String anoExpiracao,
      String mesExpiracao,
      int codSeguranca,
      String tipoCartao,
      String cpfcnpj,
      String token) async {
    Map<String, dynamic>? json =
        await cartaoCreditoDebitoProvider.cadastrarCartaoCreditoDebito(
            nomeTitular,
            numero,
            anoExpiracao,
            mesExpiracao,
            codSeguranca,
            tipoCartao,
            cpfcnpj,
            token);
    final jseon = CartaoCreditoDebito.fromJson(json!);

    return jseon;
  }

   Future<List<CartaoCreditoDebito>> listarCartoesCreditoDebito(String cpfcnpj, String token) async {
    List<CartaoCreditoDebito> listCartaoCreditoDebito = <CartaoCreditoDebito>[];
    var response = await cartaoCreditoDebitoProvider.getCartaoCredidoDebito(
        cpfcnpj, token);
    if (response != null) {
      response.forEach((e) {
        listCartaoCreditoDebito.add(CartaoCreditoDebito.fromJson(e));
      });
    }
    return listCartaoCreditoDebito;
  }

  Future<CartaoCreditoDebito> deletarCard(
      String numero, String cpfcnpj, String token) async {
    Map<String, dynamic>? json = await cartaoCreditoDebitoProvider
        .deleteCartaoCreditoDebito(numero, cpfcnpj, token);
    return CartaoCreditoDebito.fromJson(json!);
  }
}
