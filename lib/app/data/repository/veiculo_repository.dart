import 'dart:convert';

import 'package:zona_azul/app/data/models/ListaVeiculosFipe.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/data/provider/veiculo_provider.dart';

class VeiculoRepository {
  final VeiculoProvider veiculoProvider = VeiculoProvider();
 
  Future<List<ListaVeiculosFipe>> GetListaNomeVeiculos() async {
   
    List<ListaVeiculosFipe> response = await veiculoProvider.getListVeiculoApi();
   
    return response;
  }

  Future<Veiculo> cadastrar(
      String placa, String cpfcnpj, String marca, String token) async {
    Map<String, dynamic>? json =
        await veiculoProvider.cadastrarVeiculo(placa, marca, cpfcnpj, token);
    return Veiculo.fromJson(json!);
  }

 Future atualizar(String placa, String cpfcnpj, String marca, String token) async {
    Map<String, dynamic>? json =
        await veiculoProvider.atualizarVeiculo(placa, marca, cpfcnpj, token);
    return json;
  }

  Future<Veiculo> listarVeiculo(String cpfcnpj, String token) async {
    Map<String, dynamic>? json =
        await veiculoProvider.getVeiculos(cpfcnpj, token);
    return Veiculo.fromJson(json!);
  }

  listarVeiculos(String cpfcnpj, String token) async {
    List<Veiculo> listveic = <Veiculo>[];
    var response = await veiculoProvider.getVeiculos(cpfcnpj, token);
    if (response != null) {
      response.forEach((e) {
        listveic.add(Veiculo.fromJson(e));
      });
    }
    return listveic;
  }

  buscarlistarVeiculos(String cpfcnpj, String token) async {
    List<Veiculo> listveic = <Veiculo>[];
    var response = await veiculoProvider.buscarVeiculos(cpfcnpj, token);
    if (response != null) {
      response.forEach((e) {
        listveic.add(Veiculo.fromJson(e));
      });
    }
    return listveic;
  }

  apagarVeiculo(String placa, String cpfcnpj, String token) async {
    List<Veiculo> listveic = <Veiculo>[];
    var response =
        await veiculoProvider.excluirVeiculo( placa, cpfcnpj, token);
    if (response != null) {
      response.forEach((e) {
        listveic.add(Veiculo.fromJson(e));
      });
    }
    return listveic;
  }
}
