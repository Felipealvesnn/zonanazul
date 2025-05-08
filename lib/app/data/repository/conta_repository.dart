import 'package:zona_azul/app/data/models/conta_model.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';
import 'package:zona_azul/app/data/provider/conta_provider.dart';
import 'package:zona_azul/app/data/provider/login_provider.dart';

class ContaRepository {
  final ContaProvider apiClient = ContaProvider();

  Future<Conta> getConta(String token, String cpf) async {
    final json = await apiClient.retornaConta(cpf, token);
    print("${json.toString()}");
    Conta contaNulla = Conta();
    if (json == null) {
      return contaNulla;
    } else {
      Conta retorno = Conta.fromJson(json);
      print("CONTA ${retorno}");
      return retorno;
    }
  }
}
