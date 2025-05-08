import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatcurrency = NumberFormat(' ##0.00', 'pt_BR');
final Color errorColor = Colors.red.shade400; //errorColor;
const Color successColor = Colors.green; //errorColor;

//const baseUrl = 'http://w2esolucoes.ddns.net:8031/ZonaAzul/api';  //endereço desenvolvimento antigo

//endereço de produção
  const baseUrl = 'https://w2esolucoes.ddns.net/ZonaAzul/api';
// const baseUrl = 'https://localhost:44379/api';
// const baseUrl = 'http://192.168.0.23/zonaAzul/api/';
