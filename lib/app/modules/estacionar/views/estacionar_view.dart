import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:slider_button/slider_button.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/models/destino.dart';
import 'package:zona_azul/app/data/models/regra_estacionamento.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/controllers/cadastro_veiculo_controller.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/modules/estacionar/views/Widgets/CustomRadioButton.dart';
import 'package:zona_azul/app/modules/forma_de_pagamento/views/widgets/ListPagamentoButton.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:zona_azul/app/modules/meus_veiculos/controllers/meus_veiculos_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

// ignore: must_be_immutable
class EstacionarView extends GetView<EstacionarController> {
  EstacionarView({super.key});

  //CONTROLLERS LOCAIS
  TextEditingController controllerDestino = TextEditingController();
  HistoricoController historicoController = Get.find<HistoricoController>();

  //CONTROLLERS DE PAGINA
  final estacionarController = Get.find<EstacionarController>();
  final homeController = Get.find<HomeController>();
  VeiculoController veiculoController = VeiculoController();
  MeusVeiculosController meusVeiculosController =
      Get.find<MeusVeiculosController>();

  //VARIAVEIS

  bool searchEnderecoBuscado = false;

  late int cartoes;

  final _chaveFormulario = GlobalKey<FormState>();
  Set<Marker> _marcadores = {};

  bool? placaValidada,
      cpfcnpjValidada,
      latitudeValidada,
      longitudeValidada,
      regraestacionamentoidValidada,
      qtdcadssolicitadosValidada = false;

  Color backGroundSlider = errorColor;
  Color backGroundSliderEnd = const Color.fromARGB(255, 103, 199, 106);

//----------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------

  _onMapCreated(GoogleMapController controller) {
    if (!estacionarController.googleMapController.isCompleted) {
      //first calling is false
      //call "completer()"
      estacionarController.googleMapController.complete(controller);
    } else {
      //other calling, later is true,
      //don't call again completer()
      //  estacionarController.googleMapController.complete(controller);
    }
  }

  // ignore: unused_element
  _searchEndereco() async {
    String enderecoDestino = controllerDestino.text;
    List<Location> listaEnderecos = await locationFromAddress(enderecoDestino);

    if (enderecoDestino.isNotEmpty) {
      //await locationFromAddress(enderecoDestino);

      if (listaEnderecos.isNotEmpty) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            listaEnderecos.first.latitude, listaEnderecos.first.longitude);

        Placemark endereco = placemarks[0];
        Destino destino = Destino();
        destino.cidade = endereco.administrativeArea.toString();
        destino.cep = endereco.postalCode.toString();
        destino.bairro = endereco.subLocality.toString();
        destino.rua = endereco.thoroughfare.toString();
        destino.numero = endereco.subThoroughfare.toString();

        destino.latitude = listaEnderecos.first.latitude;
        destino.longitude = listaEnderecos.first.longitude;

        // ignore: unused_local_variable
        String enderecoConfirmacao;
        enderecoConfirmacao = "\n Cidade: ${destino.cidade}";
        enderecoConfirmacao += "\n Rua: ${destino.rua}, ${destino.numero}";
        enderecoConfirmacao += "\n Bairro: ${destino.bairro}";
        enderecoConfirmacao += "\n Cep: ${destino.cep}";

        estacionarController.posicaoCamera.value = CameraPosition(
            target: LatLng(destino.latitude, destino.longitude), zoom: 16);
        estacionarController
            .movimentarCamera(estacionarController.posicaoCamera.value);
        LatLng local = LatLng(destino.latitude, destino.longitude);
        estacionarController.localValid = local;

        Marker marker = Marker(
          markerId: const MarkerId("minha posicao"),
          position: local,
        );
        _marcadores.add(marker);
        //print("searchEnderecolatitude: ${destino.latitude}");
        //print("searchEnderecolongitude: ${destino.longitude}");
        Storagerds.boxcamposValidadosEstacionar
            .write('searchLat', destino.latitude);
        Storagerds.boxcamposValidadosEstacionar
            .write('searchLang', destino.longitude);
        Storagerds.boxcamposValidadosEstacionar.write('enderecoExtenso',
            "${destino.rua}, ${destino.numero}, ${destino.bairro}, ${destino.cidade}");
        Storagerds.boxcamposValidadosEstacionar
            .write('hasEnderecoSearch', true);
        //print(boxCamposValidadosEstacionar.read('enderecoExtenso'));
        estacionarController.extenso =
            "${endereco.thoroughfare}, ${endereco.subThoroughfare}, ${endereco.subAdministrativeArea}, ${endereco.administrativeArea}";

        estacionarController.localenderecoExtenso =
            estacionarController.extenso;
        searchEnderecoBuscado = true;

        //Navigator.pop(context);
      }
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    _marcadores = estacionarController.marcadores;
    estacionarController.recuperaCurrentPosition();
    searchEnderecoBuscado =
        Storagerds.boxcamposValidadosEstacionar.read('hasEnderecoTap');
    estacionarController.regraButton.value =
        Storagerds.boxBotaoRegra.read('descricaoBotao') ?? 'Selecione';

    homeController.placaButton.value =
        Storagerds.boxBotaoCarro.read('placaBotao');
    homeController.marcaButton.value =
        Storagerds.boxBotaoCarro.read('marcaBotao');

    return PopScope(
      onPopInvoked: (bools) async {
        sair();
      },
      child: Scaffold(
        key: _chaveFormulario,
        appBar: AppBar(
          title: const Text("Estacionar"),
          centerTitle: true,
        ),
        // blocUi de tela q deixei aqui caso precise usar algum dia
        body: ModalProgressHUD(
          blur: 3,
          progressIndicator: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Carregando..."),
              SizedBox(height: 15),
              CircularProgressIndicator(),
            ],
          ),
          inAsyncCall: false, //estacionarController.carregando.value,
          child: SizedBox(
            height: Get.size.height,
            width: Get.size.width,
            child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
              SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, right: 12, left: 12, bottom: 15),
                      child: SizedBox(
                        height: 90,
                        child: Obx(() => TextButton.icon(
                              icon: veiculoController.urlImageButton.value ==
                                      "assets/icons/car.png"
                                  ? const Icon(
                                      Icons.drive_eta,
                                      size: 50,
                                      color: Colors.black,
                                    )
                                  : const Icon(Icons.directions_bus,
                                      size: 50, color: Colors.black),
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Obx(
                                      () => Column(
                                        children: [
                                          Text(
                                            "${homeController.marcaButton}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${homeController.placaButton}",
                                            style: const TextStyle(
                                              fontSize: 27,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down_sharp,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                              onPressed: () {
                                final carros =
                                    Storagerds.boxListVeic.read('boxListVeic');

                                if (carros != null) {
                                  meusVeiculosController.listveic.value =
                                      carros;
                                } else {
                                  meusVeiculosController.loadVeiculos();
                                }

                                _selecionaVeiculoScaff(context);
                              },
                            )),
                      ),
                    ),
                    Stack(
                      children: [
                        Obx(
                          () =>
                              // O Mapa
                              SizedBox(
                            height: Get.size.height / 4,
                            width: Get.size.width,
                            child: GoogleMap(
                              webGestureHandling: WebGestureHandling.auto,
                              onCameraMove: (argument) {
                                print("onTapLat: ${argument} tocado no mapa");
                              },
                              mapType: MapType.normal,
                              initialCameraPosition:
                                  estacionarController.posicaoCamera.value,
                              onMapCreated: _onMapCreated,
                              //onCameraMove: adcionarListenerLocalizacao(),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,

                              zoomControlsEnabled: true,
                              zoomGesturesEnabled: true,
                              scrollGesturesEnabled: true,
                              tiltGesturesEnabled: true,

                              markers: estacionarController.marcadores.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // radio butom CAds
                    CUstomRadioButton(
                      estacionarController: estacionarController,
                    ),
                    const Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Verifique a sinalização e confirme a regra de estacionamento:",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                    ),

                    //regraButton
                    Padding(
                      padding: const EdgeInsets.only(right: 12, left: 12),
                      child: Obx(
                        () => TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed:
                              estacionarController.carregando.value == false
                                  ? () async {
                                      await _selecionaRegra(context);
                                    }
                                  : null,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${estacionarController.regraButton}",
                                      style: const TextStyle(
                                          fontSize: 25, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down_sharp,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: !estacionarController.loading.value,
                        replacement: const CircularProgressIndicator(),
                        child: criarBotaoDeslizante(),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  _estacionarButtonStyle() {
    //estilo do botao cadastrar
    return ElevatedButton.styleFrom(
      //primary: Color.fromARGB(255, 129, 212, 250),
      backgroundColor: const Color(0xFFffcc43),
      //onPrimary: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.all(12),
    );
  }

  sair() {
    Get.offAllNamed(Routes.HOME);
    homeController.onClose();
  }

//---------------------------------------------------------------------------------------------------------------------------
  SliderButton criarBotaoDeslizante() {
    return SliderButton(
      buttonColor: Get.theme.primaryColor,
      height: 60,
      width: 300,
      vibrationFlag: true,
      action: () async {
        estacionarController.loading.value = true;

        if (latitudeValidada != true) {
          estacionarController.MudarRegra = false;
          await estacionarController.recuperaCurrentPosition();
        }

        homeController.carregarCad;

        if (validarSaldoCAD() && validarCampos() && validarQtdCAD()) {
          bool confirmado = await mostrarDialogoDeConfirmacao();

          if (confirmado) {
            atribuirValoresLocais();
            Storagerds.boxcamposValidadosEstacionar.erase();
            homeController.isEstacionado.value = true;
            await estacionarController.estacionar();
          } else {
            Future.delayed(const Duration(seconds: 1), () {
              estacionarController.loading.value = false;
            });
          }
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            estacionarController.loading.value = false;
          });
        }
      },
      alignLabel: const Alignment(0.2, 0),
      label: const Text(
        "Deslize para confirmar",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
      ),
      icon: const Icon(
        Icons.double_arrow_outlined,
        color: Colors.white,
      ),
    );
  }

  Future<bool> mostrarDialogoDeConfirmacao() async {
    return await Get.defaultDialog(
          titlePadding: const EdgeInsets.all(20),
          contentPadding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 0),
          backgroundColor: Colors.white,
          title: "Estacionar",
          content: Column(
            children: [
              const Text("Confirme os dados abaixo:"),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "Placa: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    homeController.placaButton.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "Regra: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Storagerds.boxListRegras.read('listRegrasEscolhida'),
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "Local: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      // maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      estacionarController.localenderecoExtenso!,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: successColor,
              ),
              onPressed: () => Get.back(result: true),
              child: const Text(
                "Sim",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: const Text(
                "Não",
              ),
            ),
          ],
        ) ??
        false;
  }

  bool validarSaldoCAD() {
    var saldo = Storagerds.boxSaldo.read('saldo');
    var resultaod = saldo != null && saldo > 0;
    if (saldo != null && saldo > 0) {
      return resultaod;
    } else {
      exibirSnackbar("Não foi possível estacionar", "Sem Cads disponíveis");
      return resultaod;
    }
  }

  bool validarCampos() {
    return validarCampoPlaca() &&
        validarCampoCpf() &&
        validarCampoLatLang() &&
        validarCampoRegraEstacionamentoId();
  }

  void atribuirValoresLocais() {
    estacionarController.localPlaca =
        Storagerds.boxBotaoCarro.read('placaBotao');
    estacionarController.localCpfcnpj = Storagerds.boxcpf.read('cpfCnpj');

    if (Storagerds.boxcamposValidadosEstacionar.read('regraEstacionamendoID') ==
        null) {
      estacionarController.localRegraestacionamentoid = "1";
    }

    estacionarController.localRegraestacionamentoid =
        Storagerds.boxcamposValidadosEstacionar.read('regraEstacionamendoID');
    estacionarController.localqtdCADsolicitado = cartoes;
  }

  bool validarCampoPlaca() {
    if (Storagerds.boxcamposValidadosEstacionar.read('placa') == "Selecione") {
      exibirSnackbar(
          "Não foi possível estacionar", "Selecione um veículo primeiro");
      return false;
    } else {
      print(
          "Estacionado placa ${Storagerds.boxcamposValidadosEstacionar.read('placa')}");
      return true;
    }
  }

  bool validarCampoCpf() {
    if (Storagerds.boxcpf.read('cpfCnpj') != null) {
      print("CPF: ${Storagerds.boxcpf.read('cpfCnpj')}");
      return true;
    } else {
      exibirSnackbar(
          "Não foi possível estacionar", "CPF inválido, faça login novamente");
      return false;
    }
  }

  bool validarCampoLatLang() {
    var onTapLat =
        Storagerds.boxcamposValidadosEstacionar.read('onTapLat') ?? 0.00;
    var onTapLang =
        Storagerds.boxcamposValidadosEstacionar.read('onTapLang') ?? 0.00;

    // double searchLat = estacionarController.boxCamposValidadosEstacionar.read('searchLat')?? 0;
    // double searchLang = estacionarController.boxCamposValidadosEstacionar.read('searchLang')??0;

    if ((onTapLat != 0 && onTapLang != 0)) {
      estacionarController.localLatitude = onTapLat;
      estacionarController.localLongitude = onTapLang;

      return true;
    } else {
      exibirSnackbar("Localização não detectada",
          "Ative as opções de GPS/localização do aparelho");
      return false;
    }
  }

  bool validarCampoRegraEstacionamentoId() {
    final regraestacio = Storagerds.boxListRegras.read('listRegrasEscolhida');
    if (regraestacio != "Selecione" && regraestacio != null) {
      return true;
    } else {
      exibirSnackbar(
          "Não foi possível estacionar", "Selecione a regra de estacionamento");
      return false;
    }
  }

  bool validarQtdCAD() {
    final quantidadeCartoes =
        Storagerds.boxcamposValidadosEstacionar.read('qtdCADsolicitado');
    cartoes = ({'1': 1, '2': 2}[quantidadeCartoes])!;

    return true;
  }

  void exibirSnackbar(String titulo, String mensagem,
      {Color corTexto = Colors.white,
      Color corFundo = Colors.red,
      Duration duracao = const Duration(seconds: 8)}) {
    Get.snackbar(
      titulo,
      mensagem,
      colorText: corTexto,
      backgroundColor: corFundo,
      duration: duracao,
    );
  }

  Future<void> getAddressFromLatLang(lat, long) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, long);
    // ignore: unused_local_variable
    Placemark place = placemark[0];
  }
//----------------------------------------------------------------------------------------------

  void bottonSheetFormaPagamento(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext bc) {
          return Card(
            margin: const EdgeInsets.only(top: 13, left: 4, right: 4),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: Scaffold(
                floatingActionButton: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(Routes.CADASTRO_VEICULO);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, shape: const CircleBorder(),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(20), // <-- Splash color
                  ),
                  child: const Icon(Icons.add),
                ),
                body: ListView(
                  shrinkWrap: false,
                  children: [
                    Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0))),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                height: Get.height * 0.5,
                                width: Get.width * 0.5,
                                child: ListView(
                                  children: const [
                                    Column(
                                      children: [
                                        ListTile(
                                          title: Center(
                                            child: Text(
                                              "Saldo insuficiente",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          subtitle: Center(
                                            child: Text(
                                              "Selecione uma forma de pagamento para adquirir",
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 100),
                                          child: ListPagamentoButton(),
                                        )
                                        //Divider(color: Colors.black),
                                      ],
                                    ),
                                  ],
                                )),
                          ]),
                    )
                  ],
                )),
          );
        });
  }

  //modal escolher regra
  Future<void> _selecionaRegra(context) async {
    if (estacionarController.listRegras.isEmpty) {
      Future<void> reloadList() async {
        print("press");
        await estacionarController.loadRegras(Storagerds
            .boxCustomRadioCartoesValue
            .read('boxCustomRadioCartoesValue'));
        Get.back();
        _selecionaRegra(context);
      }
    }

    estacionarController.carregando.value = true;
    // if (await estacionarController.testarGpsLigado()) {
    //   await estacionarController.recuperaPositionELocal();
    // } else {
    //   await estacionarController.loadRegras(
    //     await Storagerds.boxCustomRadioCartoesValue
    //         .read('boxCustomRadioCartoesValue'),
    //   );
    // }
    estacionarController.carregando.value = false;
    final periodoMax = await Storagerds.boxSetor.read('periodoMax');

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            height: 300,
            child: Obx(
              () => Visibility(
                visible: estacionarController.listRegras.isNotEmpty,
                replacement: RefreshIndicator(
                  onRefresh: () async {
                    Get.back();
                  },
                  child: ListView(
                    children: const [
                      ListTile(
                        title: Center(
                          child: Text("Não foi possivel receber as regras"),
                        ),
                      ),
                      ListTile(
                        title: Center(
                          child:
                              Text("Verifique sua conexão e tente novamente"),
                        ),
                      ),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (periodoMax != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "Tempo máximo do setor: ${(periodoMax ~/ 3600)} Horas",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const SizedBox(
                      // color: Colors.black,
                      height: 10,
                    ), // Ajuste o espaçamento conforme necessário
                    Expanded(
                      child: ListView.builder(
                        itemCount: estacionarController.listRegras.length,
                        itemBuilder: (context, index) {
                          final RegraEstacionamento regras =
                              estacionarController.listRegras[index];

                          return Column(
                            children: [
                              ListTile(
                                title: Text("${regras.descricao}"),
                                subtitle: null,
                                onTap: () async {
                                  estacionarController.regraButton.value =
                                      regras.descricao.toString();
                                  Storagerds.boxBotaoRegra.write(
                                    'descricaoBotao',
                                    regras.descricao.toString(),
                                  );
                                  await Storagerds.boxListRegras.write(
                                    'listRegrasEscolhida',
                                    regras.descricao.toString(),
                                  );
                                  await Storagerds.boxcamposValidadosEstacionar
                                      .write(
                                    'regraEstacionamendoID',
                                    regras.regraEstacionamentoID,
                                  );
                                  Get.back();
                                },
                              ),
                              const Divider(color: Colors.black),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _selecionaVeiculoScaff(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext bc) {
          return Card(
            margin: const EdgeInsets.only(top: 13, left: 4, right: 4),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: Scaffold(
                floatingActionButton: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(Routes.CADASTRO_VEICULO);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, shape: const CircleBorder(),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(20), // <-- Splash color
                  ),
                  child: const Icon(Icons.add),
                ),
                body: ListView(
                  shrinkWrap: false,
                  children: [
                    Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0))),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: Get.height * 0.5,
                              width: Get.width * 0.5,
                              child: meusVeiculosController
                                      .listveic.value.isEmpty
                                  ? ListView(
                                      children: const [
                                        ListTile(
                                          title: Center(
                                            child: Text(
                                                "Nenhum veiculo encontrado"),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Obx(() => ListView.builder(
                                      itemCount: meusVeiculosController
                                          .listveic.length,
                                      itemBuilder: (context, index) {
                                        Veiculo veiculos =
                                            meusVeiculosController
                                                .listveic[index];

                                        return Container(
                                          child: Column(
                                            children: [
                                              ListTile(
                                                trailing: IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    veiculoController
                                                            .placaTextController =
                                                        veiculos.placa
                                                            .toString();

                                                    Get.off(EditarVeiculoView(
                                                      placa: veiculos.placa,
                                                      marca: veiculos.marca,
                                                      tipoVeiculo: Storagerds
                                                          .boxtipoVeic
                                                          .read('tipoVeic'),
                                                      cpf: veiculoController
                                                          .boxcpf
                                                          .read('cpfCnpj'),
                                                      token: veiculoController
                                                          .boxToken
                                                          .read('token'),
                                                    ));
                                                  },
                                                ),
                                                leading: Image.asset(
                                                    "assets/icons/car.png"),
                                                title:
                                                    Text("${veiculos.placa}"),
                                                subtitle:
                                                    Text("${veiculos.marca}"),
                                                onTap: () => {
                                                  homeController
                                                          .placaButton.value =
                                                      veiculos.placa.toString(),
                                                  print(homeController
                                                      .placaButton.value),
                                                  homeController
                                                          .marcaButton.value =
                                                      veiculos.marca.toString(),
                                                  print(homeController
                                                      .marcaButton.value),

                                                  Storagerds.boxBotaoCarro
                                                      .write(
                                                          'placaBotao',
                                                          veiculos.placa
                                                              .toString()),
                                                  Storagerds.boxBotaoCarro
                                                      .write(
                                                          'marcaBotao',
                                                          veiculos.marca
                                                              .toString()),
                                                  Storagerds
                                                      .boxcamposValidadosEstacionar
                                                      .write(
                                                          'placa',
                                                          veiculos.placa
                                                              .toString()),

                                                  Get.back(),
                                                  //para validação na estacionarView
                                                },
                                              ),
                                              const Divider(
                                                  color: Colors.black),
                                            ],
                                          ),
                                        );
                                      })),
                            ),
                          ]),
                    )
                  ],
                )),
          );
        });
  }

  _iconButton() {
    return Image.asset(veiculoController.urlImageButton.value);
  }

  _titleButton() {
    return Text(
      veiculoController.titleTextButton.value,
      style: const TextStyle(fontSize: 30, color: Colors.black87),
    );
  }
}
