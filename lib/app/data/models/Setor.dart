import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zona_azul/app/data/models/regra_estacionamento.dart';

class Setor {
  int? setorID;
  String? descricao;
  int? subSetorID;
  String? kml;
  double? latitude;
  double? longitude;
  dynamic? poligono;
  String? regraEstacionamentoID;
  List<dynamic>? vagas;
  double? periodoMax;
  List<PontosSetor>? pontosSetor;
  List<RegraEstacionamento>? regraEstacionamento;

  Setor({
    this.setorID,
    this.descricao,
    this.subSetorID,
    this.kml,
    this.latitude,
    this.longitude,
    this.poligono,
    this.periodoMax,
    this.regraEstacionamentoID,
    this.pontosSetor,
    this.vagas,
    this.regraEstacionamento,
  });

  factory Setor.fromJson(Map<String, dynamic> json) {
    List<dynamic> pontosJson = json['PontosSetor'];
    List<PontosSetor> pontos = pontosJson.map((pontoJson) {
      return PontosSetor.fromJson(pontoJson);
    }).toList();

    // Processa os pontos e atribui à lista pontosSetor
    return Setor(
      setorID: json['setorID'],
      descricao: json['descricao'],
      subSetorID: json['subSetorID'],
      kml: json['kml'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      regraEstacionamentoID: json['regraEstacionamentoID'],
      vagas: json['Vagas'], // Verifique se 'Vagas' é do tipo esperado
      periodoMax: json['periodoMax'],
      pontosSetor: pontos, // Atribui a lista de pontosSetor
      // Verifica se 'RegraEstacionamento' é uma lista
      regraEstacionamento: json['RegraEstacionamento'] is List
          ? json['RegraEstacionamento']
              .map<RegraEstacionamento>(
                  (regraJson) => RegraEstacionamento.fromJson(regraJson))
              .toList()
          : json['RegraEstacionamento'] != null
              ? [RegraEstacionamento.fromJson(json['RegraEstacionamento'])]
              : null,
    );
  }
  List<LatLng> getLatLngList() {
    if (pontosSetor != null || pontosSetor!.isNotEmpty) {
      return pontosSetor!.map((ponto) {
        return LatLng(ponto.latitude, ponto.longitude);
      }).toList();
    } else {
      return [];
    }
  }
  Polygon getPolygon() {
    if (pontosSetor != null || pontosSetor!.isNotEmpty) {
      List<LatLng> points = pontosSetor!.map((ponto) {
        return LatLng(ponto.latitude, ponto.longitude);
      }).toList();

      return Polygon(
        polygonId: PolygonId(setorID.toString()),
        points: points,
        strokeWidth: 2,
        strokeColor: Colors.red,
        fillColor: Colors.red.withOpacity(0.5),
      );
    } else {
      return Polygon(
        polygonId: PolygonId(setorID.toString()),
        points: [],
        strokeWidth: 2,
        strokeColor: Colors.red,
        fillColor: Colors.red.withOpacity(0.5),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['setorID'] = setorID;
    data['descricao'] = descricao;
    data['subSetorID'] = subSetorID;
    data['kml'] = kml;
    data['latitude'] = latitude;
    data['periodoMax'] = periodoMax;
    data['longitude'] = longitude;
    //data['poligono'] = poligono?.toJson();
    data['regraEstacionamentoID'] = regraEstacionamentoID;
    data['PontosSetor'] = pontosSetor;
    data['Vagas'] = vagas;
    data['RegraEstacionamento'] =
        regraEstacionamento?.map((regra) => regra.toJson()).toList();
    return data;
  }
}

class PontosSetor {
  int pontoSetorID;
  int setorID;
  double latitude;
  double longitude;

  PontosSetor({
    required this.pontoSetorID,
    required this.setorID,
    required this.latitude,
    required this.longitude,
  });

  factory PontosSetor.fromJson(Map<String, dynamic> json) {
    return PontosSetor(
      pontoSetorID: json['pontoSetorID'],
      setorID: json['setorID'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
