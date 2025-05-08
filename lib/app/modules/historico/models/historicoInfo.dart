import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';

class HistoricoInfo {
  RxString? placa;
  RxString? valor;
  RxString? regra;
  RxString? localchaveAutenticacao;
  RxString? regraDesc;
  RxString? tempoDeEstacionamento;
  RxString? dataInicio;
  RxString? dataFim;
  RxString? localEstacionado;

  HistoricoInfo({
    RxString? placa,
    RxString? valor,
    RxString? regra,
    RxString? localchaveAutenticacao,
    RxString? regraDesc,
    RxString? tempoDeEstacionamento,
    RxString? dataInicio,
    RxString? dataFim,
    RxString? localEstacionado,
  }) {
    this.placa = placa ?? RxString("BBBB");
    this.valor = valor ?? RxString("BBBBB");
    this.regra = regra ?? RxString("BBBBB");
    this.localchaveAutenticacao = localchaveAutenticacao ?? RxString("--");
    this.regraDesc = regraDesc ?? RxString("BBBBB");
    this.tempoDeEstacionamento = tempoDeEstacionamento ?? RxString("BBBBB");
    this.dataInicio = dataInicio ?? RxString("BBBBB");
    this.dataFim = dataFim ?? RxString("BBBBB");
    this.localEstacionado = localEstacionado ?? RxString("BBBBB");
  }
  void definirDataInicio(DateTime dataInicio) {
    this.dataInicio!.value =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(dataInicio);
  }

  void definirdataFim(DateTime dataInicio) {
    dataFim!.value = DateFormat("dd/MM/yyyy HH:mm:ss").format(dataInicio);
  }
}
