import 'package:zona_azul/app/data/models/regra_estacionamento.dart';
import 'package:zona_azul/app/data/provider/regras_provider.dart';

class RegrasRepository {
  final RegrasProvider regrasProvider = RegrasProvider();

  Future<RegraEstacionamento> getRegras(String token) async {
    Map<String, dynamic>? json = await regrasProvider.getRegras(token);
    return RegraEstacionamento.fromJson(json!);
  }

  Future<List<RegraEstacionamento>> listarRegras(String token) async {
    List<RegraEstacionamento> listreg = <RegraEstacionamento>[];
    var response = await regrasProvider.getRegras(token);
    if (response != null) {
      response.forEach((e) {
        listreg.add(RegraEstacionamento.fromJson(e));
      });
    }
    return listreg;
  }
}
