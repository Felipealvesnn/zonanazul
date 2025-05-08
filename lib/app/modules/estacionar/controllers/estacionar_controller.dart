import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as localts;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waiter/waiter.dart';
import 'package:zona_azul/app/data/models/Setor.dart';
import 'package:zona_azul/app/data/models/estacionarApi_model.dart';
import 'package:zona_azul/app/data/models/regra_estacionamento.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/data/repository/estacionar_repository.dart';
import 'package:zona_azul/app/data/repository/regras_repository.dart';
import 'package:zona_azul/app/data/repository/veiculo_repository.dart';
import 'package:zona_azul/app/modules/estacionar/funcoes/funcoes.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/GoogleMapUtils.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class EstacionarController extends GetxController {
  WaiterController waiterController = WaiterController();

  HistoricoController historicoEstacionamento = Get.find<HistoricoController>();
  HomeController homeController = Get.find<HomeController>();
  // final Completer<GoogleMapController> _googleMapController = Completer();
  final Completer<GoogleMapController> googleMapController = Completer();
  late Rx<CameraPosition> posicaoCamera = const CameraPosition(
    target: LatLng(-23.563999, -46.653256),
  ).obs;

  String? extenso;
  RxBool carregando = false.obs;
  final int helloAlarmID = 1;
  RxBool adicionar1HoraButton = false.obs;
  var cpf = Storagerds.boxcpf.read('cpfCnpj');
  var token = Storagerds.boxToken.read('token');
  final boxAdicionar1HoraButton = GetStorage('boxAdicionar1HoraButton');
  final boxDateTimeAlarm = GetStorage("boxDateTimeAlarm");

  List<RegraEstacionamento> regrasAll = <RegraEstacionamento>[];

  RxBool loading = false.obs;

  RxString regraButton = "".obs;
  bool MudarRegra = true;
  LatLng localValid = const LatLng(0, 0);
  RxString buttonCartaoSelected = "0".obs;

//Variaveis para Estacionar
  String? localPlaca;
  String? SetorSelecionado;
  String? localCpfcnpj;
  double? localLatitude;
  double? localLongitude;
  RxSet<Marker> marcadores = <Marker>{}.obs;
  late Setor setor;

  String? localRegraestacionamentoid;
  String? localenderecoExtenso;
  int? localqtdCADsolicitado;
  RxBool estacionadoSucesso = false.obs;

  final regrasRepository = RegrasRepository();
  final estacionarRepository = Get.put(EstacionarRepository());
  final VeiculoRepository veicrepository = VeiculoRepository();

  RxList<RegraEstacionamento> listRegras = <RegraEstacionamento>[].obs;
  RxList<RegraEstacionamento> listFilter = <RegraEstacionamento>[].obs;
  RxList<Veiculo> listFilterVeiculos = <Veiculo>[].obs;
  RxInt filtroCartoesListRegra = 1.obs;

  Future<void> loadRegras(int filtro, {bool? SetorIstrue}) async {
    filtroCartoesListRegra.value = filtro;
    SetorIstrue = SetorIstrue ?? false;

    if (!SetorIstrue) {
      // 1) Busca tudo do servidor
      final todasAsRegras = await regrasRepository.listarRegras(token);

      // 2) Se não for Crato, mantém só as regras 1 e 7
      if (homeController.cidade.value == 'Crato') {
        regrasAll = todasAsRegras.where((r) {
          return r.regraEstacionamentoID == '1' ||
              r.regraEstacionamentoID == '7';
        }).toList();
      } else {
        // caso seja Crato, mantém tudo
        regrasAll = todasAsRegras;
      }

      // 3) Persiste e atualiza o filtro
      Storagerds.boxListRegras.write('listRegras', regrasAll);
      await Storagerds.boxSetor.write('periodoMax', null);
      listFilter.value = regrasAll;
    }

    // 4) aplica o filtro atual
    FiltrarRegraEstacionamento(filtro);
  }

  Future<void> FiltrarRegraEstacionamento(int filtro) async {
    if (filtro == 1) {
      listRegras.value = listFilter.where((item) => item.tipoCad == 1).toList();
      // boxListRegras.write('listRegrasEscolhida', listRegras[0]);

      setarBoxDeEscolhaDeRegra(listRegras[0].descricao);
    } else if (filtro == 2) {
      listRegras.value = listFilter.where((item) => item.tipoCad == 2).toList();
      // boxListRegras.write('listRegrasEscolhida', listRegras[0]);
      setarBoxDeEscolhaDeRegra(listRegras[0].descricao);
    }
  }

  setarBoxDeEscolhaDeRegra(String? regra) async {
    if (MudarRegra) {
      regraButton.value = regra!;

      await Storagerds.boxcamposValidadosEstacionar
          .write('regraEstacionamendoID', listRegras[0].regraEstacionamentoID);
      Storagerds.boxListRegras.write('listRegrasEscolhida', regraButton.value);
      Storagerds.boxBotaoRegra.write('descricaoBotao', regraButton.value);
    } else {
      MudarRegra = true;
    }
  }

  Future<void> estacionar() async {
    try {
      loading.value = true;

      // if (localLatitude == null || localLongitude == null) {
      //   Get.snackbar(
      //     "Erro ao estacionar",
      //     "Localização inválida.",
      //     colorText: Colors.white,
      //     backgroundColor: errorColor,
      //     duration: const Duration(seconds: 3),
      //     snackPosition: SnackPosition.TOP,
      //   );
      //   return;
      // }

      var estacionado = await estacionarRepository.estacionarRepository(
          localPlaca.toString(),
          localCpfcnpj.toString(),
          localLatitude!,
          localLongitude!,
          localenderecoExtenso.toString(),
          localRegraestacionamentoid!,
          localqtdCADsolicitado!,
          token);

      if (estacionado.mensagem != "Saldo Insuficiente!") {
        estacionadoSucesso.value = true;
        Storagerds.boxSaldo.write('saldo', estacionado.saldo);
        // await NotificacoesGerais.notificarEstacionar(
        //     estacionado.tempoEstacionamento);
        localLatitude = null;
        // Get.back();
        Get.offAllNamed(Routes.HOME);
        loading.value = false;
        Get.snackbar(
          "Sucesso",
          estacionado.mensagem.toString(),
          colorText: Colors.white,
          backgroundColor: successColor,
          duration: const Duration(seconds: 2),
        );

        // await homeController.loadingHomeINici();
      } else {
        loading.value = false;
        estacionadoSucesso.value = false;
        Storagerds.boxEstacionadoComSucesso
            .write('boxEstacionadoComSucesso', false);
        homeController.isEstacionado.value = false;

        Get.snackbar(
          "Erro ao estacionar",
          estacionado.mensagem.toString(),
          colorText: Colors.white,
          backgroundColor: errorColor,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      loading.value = false;
      print("Erro: $e");
      Get.snackbar(
        "Erro ao estacionar",
        "Ocorreu um erro ao estacionar.",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> renovar(String autenticacao) async {
    try {
      EstacionarApi renovado = await estacionarRepository
          .renovarEstacionamentoRepository(autenticacao, cpf, token);

      if (renovado.mensagem != "Saldo Incuficiente!") {
        Storagerds.boxBotaoRegra.write('descricaoBotao', "Selecione");

        estacionadoSucesso.value = true;
        homeController.isEstacionado.value = true;

        Storagerds.boxEstacionadoComSucesso
            .write('boxEstacionadoComSucesso', true);

        Get.snackbar(
          "Sucesso",
          renovado.mensagem.toString(),
          colorText: Colors.white,
          backgroundColor: successColor,
          duration: const Duration(seconds: 2),
        );

        await _processarRenovacao(renovado);
      } else {
        _tratarErroRenovacao(renovado.mensagem!);
      }
    } catch (e) {
      _tratarErroRenovacao(e.toString());
    }
  }

  Future<void> _processarRenovacao(EstacionarApi renovado) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      await FuncoesParaAjudar.renovarNotificacao(renovado.tempoEstacionamento!);

      Storagerds.boxSaldo.write('saldo', renovado.saldo);
      Storagerds.boxcamposValidadosEstacionar.write('enderecoExtenso', null);
      localLatitude = null;

      Storagerds.boxTimer.write('timer', renovado.tempoEstacionamento);
      Storagerds.boxDataInicio.write('boxDataInicio', renovado.dataHoraInicio);
      Storagerds.boxDataFim.write('boxDataFim', renovado.dataHoraFim);

      _limparCamposValidadosEstacionar();
      Storagerds.boxbotaoEstacionarHabilitado
          .write('boxbotaoEstacionarHabilitado', false);
      historicoEstacionamento.loadHistoricoEstacionamento();

      loading.value = true;
    });
  }

  void _limparCamposValidadosEstacionar() {
    Storagerds.boxcamposValidadosEstacionar.write('onTapLat', 0.0);
    Storagerds.boxcamposValidadosEstacionar.write('onTapLang', 0.0);
    Storagerds.boxcamposValidadosEstacionar.write('searchLat', 0);
    Storagerds.boxcamposValidadosEstacionar.write('searchLang', 0);
    Storagerds.boxcamposValidadosEstacionar.write('hasEnderecoTap', false);
    Storagerds.boxcamposValidadosEstacionar.write('hasEnderecoSearch', false);
    Storagerds.boxcamposValidadosEstacionar.write('qtdCADsolicitado', "1");
  }

  void _tratarErroRenovacao(String mensagem) {
    estacionadoSucesso.value = false;
    Storagerds.boxEstacionadoComSucesso
        .write('boxEstacionadoComSucesso', false);
    homeController.isEstacionado.value = false;
    loading.value = true;

    Get.snackbar(
      "Não foi possível renovar",
      mensagem,
      colorText: Colors.white,
      backgroundColor: errorColor,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<bool> testarGpsLigado() async {
    localts.Location location = localts.Location();
    bool enabled = await location.serviceEnabled();
    if (!enabled) {
      enabled = await location.requestService();

      return enabled;
    }
    return enabled;
  }

  Future<Map<String, dynamic>> recuperaPositionELocal() async {
    // Recupera a posição atual do dispositivo
    Position position = await FuncoesParaAjudar.recuperaPosition();
    if (homeController.cidade.value != "Crato") {
      // pq no crato não tem setor
      await carregarSetorERegra(position);
    }

    // Cria um mapa para armazenar a posição e o local
    Map<String, dynamic> result = {
      'position': position,
      'local': LatLng(position.latitude, position.longitude),
    };

    return result;
  }

  Future<void> recuperaCurrentPosition() async {
    // Chama a função para obter a posição e o local
    if (!await testarGpsLigado()) return;

    Map<String, dynamic> data = await recuperaPositionELocal();

    Position position = data['position'];
    LatLng local = data['local'];

    Marker marker = Marker(
      markerId: const MarkerId("minha posicao"),
      position: local,
    );

    marcadores.value = {marker};

    var endereco =
        await pegarEnderecoPorExtenso(position.latitude, position.longitude);
    localenderecoExtenso = endereco.join(', ');
    //  homeController.cidade.value = endereco[2];

    Storagerds.boxcamposValidadosEstacionar.write('hasEnderecoTap', true);

    posicaoCamera.value = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 16);
    await movimentarCamera(posicaoCamera.value);
    Storagerds.boxcamposValidadosEstacionar
        .write('onTapLat', position.latitude);
    Storagerds.boxcamposValidadosEstacionar
        .write('onTapLang', position.longitude);
  }

  Future<void> carregarSetorERegra(Position position) async {
    try {
      bool noSetor = false; // await ChecarSetorIsTrue(position);
      int regraValue = await converterEscolherRegraValueInInt();

      if (!noSetor) {
        setor = await estacionarRepository.GetSetore(
              token,
              position.longitude.toString(),
              position.latitude.toString(),
            ) ??
            Setor();

        if (setor.descricao != null) {
          await Storagerds.boxSetor.write('Setor', setor);

          if (setor.regraEstacionamento?.isNotEmpty ?? false) {
            if (SetorSelecionado != setor.descricao) {
              await Storagerds.boxSetor.write('periodoMax', setor.periodoMax);
              listFilter.value = setor.regraEstacionamento!;
              SetorSelecionado = setor.descricao;
              await FiltrarRegraEstacionamento(regraValue);
            }
          } else {
            await loadRegras(regraValue);
          }
        } else {
          await loadRegras(regraValue, SetorIstrue: noSetor);
        }
      } else {
        await loadRegras(regraValue, SetorIstrue: noSetor);
      }
    } catch (e) {
      print('An error occurred: $e');
      // Consider adding more error handling here
    }
  }

  Future<bool> ChecarSetorIsTrue(Position position) async {
    try {
      LatLng point = LatLng(position.latitude, position.longitude);
      // funcao pra chegar se ainda ta dentro do setor, ai evita ficar refazendo request na api...
      return GoogleMapUtils.isPointInsidePolygon(point, setor.getLatLngList());
    } catch (e) {
      print(e);
      return false;
    }
  }

  movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController sgoogleMapController = await googleMapController.future;
    sgoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  resetSelecao() {
    regraButton.value = 'Selecione';
    Storagerds.boxListRegras.write('listRegrasEscolhida', 'Selecione');
    Storagerds.boxBotaoRegra.write('descricaoBotao', 'Selecione');
  }

  Future<int> converterEscolherRegraValueInInt() async {
    int valorInt;
    var valorButoom = await Storagerds.boxCustomRadioCartoesValue
            .read('boxCustomRadioCartoesValue') ??
        1;

    if (valorButoom is String) {
      valorInt = int.tryParse(valorButoom) ?? 0;
    } else if (valorButoom is int) {
      valorInt = valorButoom;
    } else {
      valorInt = 1;
      Storagerds.boxCustomRadioCartoesValue
          .write('boxCustomRadioCartoesValue', 1);
    }
    return valorInt;
  }

  Future<void> CarregarRregrasBox() async {
    var dataList = await Storagerds.boxListRegras.read('listRegras');

    try {
      if (dataList != null) {
        regrasAll = dataList is List<RegraEstacionamento>
            ? dataList
            : dataList
                .map<RegraEstacionamento>(
                    (item) => RegraEstacionamento.fromJson(item))
                .toList();

        print(regrasAll);
      }
    } catch (e) {
      print(e);
    }
  }

  Future cancelarEstacioname() async {
    try {
      // cancelar a
      waiterController.showLoading();
      //s notificações do estacionamento
      await AwesomeNotifications().cancelAllSchedules();

      var json = await estacionarRepository.cancelarEstacioname();
      return json;
    } on Exception catch (e) {
      print(e);
      // TODO
    } finally {
      // Fecha o diálogo de carregamento
      waiterController.hiddenLoading('');
    }
  }

  @override
  void onInit() async {
    try {
      // Atualiza a posição do mapa com base nos dados do sensor

      // notificationsFlutterLocal.checkForNotifications();

      await CarregarRregrasBox();
      await getSetorBox();
      final valorButoom = Storagerds.boxCustomRadioCartoesValue
              .read('boxCustomRadioCartoesValue') ??
          1;

      int valorInt = await converterEscolherRegraValueInInt();

      await loadRegras(valorInt);

      await recuperaCurrentPosition();

      regraButton.value = Storagerds.boxBotaoRegra.read('descricaoBotao') ?? '';
    } catch (e) {
      print(e);
    }

    estacionadoSucesso.value = false;
    //homeController.recuperaPosition();

    super.onInit();
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //  await funcaoinicialRegraButton();
    await funcaoinicialVeiculoButton();
  }

  @override
  void onClose() {
    super.onClose();
    Storagerds.boxcamposValidadosEstacionar.write('onTapLat', 0.0);
    Storagerds.boxcamposValidadosEstacionar.write('onTapLang', 0.0);
    Storagerds.boxcamposValidadosEstacionar.write('searchLat', 0);
    Storagerds.boxcamposValidadosEstacionar.write('searchLang', 0);
    Storagerds.boxcamposValidadosEstacionar.write('hasEnderecoTap', false);
    Storagerds.boxcamposValidadosEstacionar.write('hasEnderecoSearch', false);
    Storagerds.boxcamposValidadosEstacionar.write('placa', "Selecione");
    // boxCamposValidadosEstacionar.write('regraEstacionamendoID', "Selecione");
    Storagerds.boxcamposValidadosEstacionar.write('qtdCADsolicitado', "1");
    Storagerds.boxListRegras.erase();
  }

  Future<void> getSetorBox() async {
    final boxSEtor = Storagerds.boxSetor.read('Setor');

    if (boxSEtor == null || boxSEtor.isEmpty) {
      setor = Setor();
    } else {
      if (boxSEtor is Setor) {
        setor = boxSEtor;
      } else if (boxSEtor is Map) {
        if (boxSEtor['setorID'] == null) {
          setor = Setor();
        } else {
          setor = Setor.fromJson(boxSEtor as Map<String, dynamic>);
        }
        // data é um mapa
      }
    }
  }

  recuperaTempoEstacionamento(int valor) {
    String tempoFinal = '';
    switch (valor) {
      case 1800:
        {
          tempoFinal = "30 minutos";
        }
        break;
      case 3600:
        {
          tempoFinal = "1 hora";
        }
        break;
      case 7200:
        {
          tempoFinal = "2 horas";
        }
        break;
      case 18000:
        {
          tempoFinal = "5 horas";
        }
        break;
      case 60:
        {
          tempoFinal = "1 min";
        }
        break;
    }

    return tempoFinal;
  }

  Future<void> funcaoinicialVeiculoButton() async {
    var cpf = Storagerds.boxcpf.read('cpfCnpj');
    var token = Storagerds.boxToken.read('token');

    try {
      final veiculos = Storagerds.boxListVeic.read('boxListVeic');
      //
      //
      listFilterVeiculos.value = veiculos;

      //

      if (listFilterVeiculos.value.isNotEmpty) {
        Veiculo veiculo = listFilterVeiculos[0];
        homeController.marcaButton.value = veiculo.marca.toString();
        Storagerds.boxBotaoCarro.write('marcaBotao', veiculo.marca.toString());
        //]
        homeController.placaButton.value = veiculo.placa.toString();
        Storagerds.boxBotaoCarro.write('placaBotao', veiculo.placa.toString());
        Storagerds.boxcamposValidadosEstacionar
            .write('placa', veiculo.placa.toString());
      }
    } catch (e) {
      Storagerds.boxBotaoCarro.write('marcaBotao', "");
      homeController.marcaButton.value = "";
      Storagerds.boxBotaoCarro.write('placaBotao', "Selecione");
      homeController.placaButton.value = "Selecione";
      Storagerds.boxcamposValidadosEstacionar.write('placa', "Selecione");
    }
  }

  verificarSaldoCAD() {
    var saldo = Storagerds.boxSaldo.read('saldo');
    if (saldo == null) {
      return false;
    } else if (saldo > 0) {
      return true;
    } else {
      return false;
    }
  }

  final testes = funcoesEStacionar();
}
