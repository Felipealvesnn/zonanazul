import 'package:zona_azul/app/data/models/pagamento.dart';
import 'package:zona_azul/app/data/provider/pagamentro_provider.dart';

class EstacionarRepository {
  final apiClient = PagamentoProvider();

  Future<Pagamento> pagamentoRepository(
      int qtdCAD,
      String cpf,
      String numeroCartao,
      String tipoPagamento,
      double valor,
      String token) async {
    Map<String, dynamic>? json = await apiClient.postPagamentoProvider(
        qtdCAD, cpf, numeroCartao, tipoPagamento, valor, token);
    Pagamento userNullo = Pagamento();
    if (json == null) {
      return userNullo;
    } else {
      return Pagamento.fromJson(json);
    }
  }
}
