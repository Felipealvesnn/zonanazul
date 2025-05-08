import 'package:zona_azul/app/data/models/Setor.dart';
import 'package:zona_azul/app/data/models/estacionarApi_model.dart';
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/data/provider/estacionarApi_provider.dart';

class EstacionarRepository {
  final EstacioProvider apiClient = EstacioProvider();

  Future<EstacionarApi> estacionarRepository(
      String placa,
      String cpfcnpj,
      double? latitude,
      double? longitude,
      String local,
      String regraestacionamentoid,
      int qtdCADsolicitado,
      String token) async {
    Map<String, dynamic>? json = await apiClient.estacionarProvider(
        placa,
        cpfcnpj,
        latitude,
        longitude,
        local,
        regraestacionamentoid,
        qtdCADsolicitado,
        token);
    EstacionarApi userNullo = EstacionarApi();
    if (json == null) {
      return userNullo;
    } else {
      return EstacionarApi.fromJson(json);
    }
  }

  Future<Setor?> GetSetore(
      String token, String longitude, String latitude) async {
    try {
      final json = await apiClient.GetSetor(token,
          latitude: latitude, longitude: longitude);

      if (json == null) {
        // Caso o JSON seja nulo, lança uma exceção com uma mensagem descritiva
        return Setor();
      }

      // Se o JSON não for nulo, continua o processamento
      return json;
    } catch (e) {
      // Captura qualquer exceção ocorrida no bloco try e imprime a mensagem de erro
      print('Erro ao obter e processar o JSON: $e');

      // Retorna uma instância de EstacionarApi indicando um erro
      return null;
    }
  }

  //
  //
  Future<EstacionarApi> renovarEstacionamentoRepository(
      String chaveAutenticacao, String cpfcnpj, String token) async {
    Map<String, dynamic>? json = await apiClient.renovarEstacionarProvider(
        chaveAutenticacao, cpfcnpj, token);
    EstacionarApi userNullo = EstacionarApi();
    if (json == null) {
      return userNullo;
    } else {
      return EstacionarApi.fromJson(json);
    }
  }

  Future cancelarEstacioname() async {
    var json = await apiClient.cancelarEstacioname();
    if (json == null) {
      return null;
    } else {
      return HistoricoEstacionamento.fromJson(json);
    }
  }


}
