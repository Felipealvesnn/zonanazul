import 'package:zona_azul/app/data/models/cad.dart';
import 'package:zona_azul/app/data/provider/cad_provider.dart';

class CadRepository {
  final CadProvider cadProvider = CadProvider();

  Future<Cad> getCads(String token) async {
    Map<String, dynamic>? json = await cadProvider.getCads(token);
    return Cad.fromJson(json!);
  }

  listarCads(String token) async {
    List<Cad> listcad = <Cad>[];
    var response = await cadProvider.getCads(token);
    if (response != null) {
      response.forEach((e) {
        listcad.add(Cad.fromJson(e));
      });
    }

    return listcad;
  }

  Future pagarCads(int qtdCads, String cpf, String token, String numeroCartao,
      String tipoPagamento, double valor) async {
    try {
      var json = await cadProvider.payCads(
          qtdCads, cpf, numeroCartao, tipoPagamento, valor);
      var cad = Cad.fromJson(json as Map<String, dynamic>);
      return cad;
    } catch (err) {
      print("Erro ao pagar CADs: $err");
      // Trate o erro de forma apropriada
      throw err; // Propague a exceção para cima
    }
  }
}
