import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_cli/samples/impl/get_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:zona_azul/app/data/models/historicoLog.dart';
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/data/repository/historicoEstacionamento_repository.dart';
import 'package:zona_azul/app/modules/historico/models/historicoInfo.dart';
import 'package:zona_azul/app/modules/home/views/widgets/componentsBody/contador.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';
import 'package:zona_azul/app/utils/gerarNotificacao.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

HistoricoEstacionamentoRepository histoEstaRepository =
    HistoricoEstacionamentoRepository();

class HistoricoController extends GetxController {
  CountDownController countDownController = CountDownController();
  RxString searchTitle = ''.obs;

  RxBool isloadingPageHitory = true.obs;

  // variaveis estacionar do contador

  RxBool ispaused = false.obs;

  RxBool finalTime = false.obs;
  RxBool botaoEstacionarHabilitado = true.obs;

  List<HistoricoEstacionamento> historicoTotal = <HistoricoEstacionamento>[];
  List<HistoricoLog> historicoLogTotal = <HistoricoLog>[]; 

  RxList<HistoricoEstacionamento> historico = <HistoricoEstacionamento>[].obs;
  RxList<HistoricoLog> historicoLoglist = <HistoricoLog>[].obs;

  //http://192.168.0.31/ZonaAzul/api/HistoricoEstacionamento/02455929388

  Future<void> functionAtualizarHistoricoEComralog() async {
    try {
      final cpf = Storagerds.boxcpf.read('cpfCnpj');
      final token = Storagerds.boxToken.read('token');
      final dynamic data =
          Storagerds.boxListHistorico.read('boxHistoricoEcomprasLog');

      isloadingPageHitory.value = true;
      if (data == null) {
        await carregarHistorioElog();
      } else {
        if (data is List<HistoricoLog>) {
          historicoLogTotal.assignAll(data);
        } else if (data is List) {
          // data é um mapa
          final List<HistoricoLog> historicoList = [];

          data.forEach((v) {
            historicoList.add(HistoricoLog.fromJson(v));
          });
          print('data é um mapa');
          historicoLogTotal.assignAll(historicoList);
        } else {
          FuncoesParaAjudar.logger.d('data não é um mapa');
        }
        historicoLoglist.value = historicoLogTotal;
      }
    } catch (e) {
      // Trate erros de chamada à API aqui
    } finally {
      isloadingPageHitory.value = false;
    }
  }

  Future<void> carregarHistorioElog() async {
    final cpf = Storagerds.boxcpf.read('cpfCnpj');
    final token = Storagerds.boxToken.read('token');
    final updatedHistoricoLog =
        await histoEstaRepository.getHistoricoEcomprasLog(cpf, token);
    historicoLogTotal.assignAll(updatedHistoricoLog);
    Storagerds.boxListHistorico
        .write('boxHistoricoEcomprasLog', updatedHistoricoLog);
  }

  Future<void> functionAtualizarHistoricoEstacionamento() async {
    try {
      final cpf = Storagerds.boxcpf.read('cpfCnpj');
      final token = Storagerds.boxToken.read('token');
      final dynamic data = Storagerds.boxListHistorico.read('boxListHistorico');

      isloadingPageHitory.value = true;
      if (data == null) {
        final updatedHistorico = await histoEstaRepository
            .listarUltimoHistoricoEstacionamento(cpf, token);
        historicoTotal.assignAll(updatedHistorico);
      } else {
        if (data is List<HistoricoEstacionamento>) {
          historicoTotal.assignAll(data);
        } else if (data is List) {
          // data é um mapa
          final List<HistoricoEstacionamento> historicoList = [];

          data.forEach((v) {
            historicoList.add(HistoricoEstacionamento.fromJson(v));
          });
          print('data é um mapa');
          historicoTotal.assignAll(historicoList);
        } else {
          FuncoesParaAjudar.logger.d('data não é um mapa');
        }
        historico.value = historicoTotal;
      }
    } catch (e) {
      // Trate erros de chamada à API aqui
    } finally {
      isloadingPageHitory.value = false;
    }
  }

  Future<void> loadHistoricoEstacionamento() async {
    await functionAtualizarHistoricoEstacionamento();
  }

  Future<void> FiltrohistoricoCarregado({String? query}) async {
    if (query != null && query.isNotEmpty) {
      historico.value = historicoTotal
          .where((element) => element.placa!.contains(query))
          .toList();
    } else {
      historico.value = historicoTotal;
    }
  }

  Future<void> FiltrohistoricoElogCarregado({String? query}) async {
    if (query != null && query.isNotEmpty) {
      historicoLoglist.value = historicoLogTotal
          .where((element) { 
            if (element.estacionamento != null) {
              return element.estacionamento!.placa!.contains(query);
            }
            return false;
          })
          .toList();
    } else {
      historicoLoglist.value = historicoLogTotal;
    }
  }

  Future<void> filtoHistorico(
    String query, {
    String? dataInicial,
    String? dataFinal,
  }) async {
    String cpf = Storagerds.boxcpf.read('cpfCnpj');
    String token = Storagerds.boxToken.read('token');

    List<HistoricoEstacionamento> listHistoricoEsta = [];

    if (query.isNotEmpty || (dataInicial != null && dataFinal != null)) {
      // Verifica se há uma consulta de busca ou datas inicial/final especificadas
      listHistoricoEsta =
          await histoEstaRepository.listarUltimoHistoricoEstacionamento(
        query.isNotEmpty ? query : cpf,
        token,
        dataInicial: dataInicial,
        dataFinal: dataFinal,
      );

      historicoTotal = listHistoricoEsta;
      await FiltrohistoricoCarregado();
    } else {
      functionAtualizarHistoricoEstacionamento();
    }
  }
   Future<void> filtoHistoricoElogmoviment(
    String query, {
    String? dataInicial,
    String? dataFinal,
  }) async {
    String cpf = Storagerds.boxcpf.read('cpfCnpj');
    String token = Storagerds.boxToken.read('token');

    List<HistoricoLog> listHistoricoEsta = [];

    if (query.isNotEmpty || (dataInicial != null && dataFinal != null)) {
      // Verifica se há uma consulta de busca ou datas inicial/final especificadas
      listHistoricoEsta =
          await histoEstaRepository.getHistoricoEcomprasLog(
        query.isNotEmpty ? query : cpf,
        token,
        dataInicial: dataInicial,
        dataFinal: dataFinal,
      );

      historicoLogTotal = listHistoricoEsta;
      await FiltrohistoricoElogCarregado();
    } else {
      functionAtualizarHistoricoEComralog();
    }
  }

  @override
  void onInit() async {
    debounce(
      searchTitle,
      (callback) {
        FiltrohistoricoElogCarregado(query: searchTitle.toUpperCase());
        update();
      },
      time: const Duration(seconds: 2),
    );
        await carregarHistorioElog();
    //await loadUltimoHistoricoEstacionamento();
    super.onInit();
  }

  @override
  void onClose() {}
  @override
  void onReady() async {
        await functionAtualizarHistoricoEComralog();

    // TODO: implement onReady
    super.onReady();
  }
}

devolverEndereco(double latitude, double longitude) async {
  final locais = await placemarkFromCoordinates(latitude, longitude);
  Placemark destiny = locais[0];

  var rua = destiny.thoroughfare;
  var numero = destiny.subThoroughfare;
  var bairro = destiny.subLocality;
  var cidade = destiny.subAdministrativeArea;
  var estado = destiny.administrativeArea;
  var pais = destiny.country;
  return "${rua.toString()}, ${numero.toString()}, ${cidade.toString()}, ${estado.toString()}";
}
