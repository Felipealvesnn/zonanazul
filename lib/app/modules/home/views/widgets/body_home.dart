import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:waiter/waiter.dart';
import 'package:zona_azul/app/data/global/constants.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/data/provider/veiculo_provider.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/controllers/cadastro_veiculo_controller.dart';
import 'package:zona_azul/app/modules/comprar_cad_semBarr.dart/comprar_cad_view_semBarr.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/GetXSwitchState.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/home/views/widgets/componentsBody/CircularProgressIndicatorNamao.dart';
import 'package:zona_azul/app/modules/home/views/widgets/componentsBody/bodyCard.dart';
import 'package:zona_azul/app/modules/home/views/widgets/componentsBody/contador.dart';
import 'package:zona_azul/app/modules/home/views/widgets/shimmer.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/theme/tema.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class bodyHome extends StatefulWidget {
  const bodyHome({super.key});

  @override
  State<bodyHome> createState() => _bodyHomeState();
}

class _bodyHomeState extends State<bodyHome> with WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;
  RxInt contador = 0.obs;
  RxBool finalTime = false.obs;

  HomeController homeController = Get.find<HomeController>();

  HistoricoController historicoController = Get.find<HistoricoController>();

  EstacionarController estacionarController = Get.find<EstacionarController>();

  final GetXSwitchState getXSwitchState = Get.put(GetXSwitchState());

  VeiculoController cont = VeiculoController();

  VeiculoProvider veicprov = VeiculoProvider();

  var veics = <Veiculo>[];

  _getUsers(String cpfcnpj, String token) {
    veicprov.getVeiculos(cpfcnpj, token).then((response) {
      Iterable lista = json.decode(response.body);
      veics = lista.map((model) => Veiculo.fromJson(model)).toList();
    });
  }

  RxInt tempo = 0.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Adiciona um callback para ser chamado após o frame atual ser construído
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reloadList();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Atualiza a tela quando o aplicativo volta do segundo plano
      setState(() {
        // contador.value = homeController.startContador.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Inicia o contador
    contador.value = homeController.startContador.value;
    ever(homeController.startContador, (callback) {
      contador.value = callback as int;
    });

    return Obx(() {
      return RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () => reloadList(reloadREgra: true),
        child: Visibility(
          replacement: const Center(child: CircularProgressIndicator()),
          visible: homeController.isLoadingHome.value,

          // Aqui começamos o LayoutBuilder
          child: Waiter(
            controller: Get.find<EstacionarController>().waiterController,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ListView(
                  // Garante pelo menos a altura total da tela
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      // Centraliza todo o conteúdo verticalmente
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 14, right: 12, left: 14),
                          //   child: Text(
                          //     "MEUS CADS",
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //       fontSize: 18,
                          //       letterSpacing: 1.2,
                          //       fontWeight: FontWeight.w600,
                          //       color: getXSwitchState.textMeusCads.value
                          //           ? Get.theme.primaryColor
                          //           : const Color(0xFF6B7280), // cinza elegante
                          //     ),
                          //   ),
                          // ),

                          //---------------------------------row-----------------------------------------
                          // Row(
                          //   children: [
                          //     const Expanded(child: Divider(color: Colors.white)),
                          //     Padding(
                          //       padding:
                          //           const EdgeInsets.only(top: 1.0, right: 12, left: 12),
                          //       child: Obx(
                          //         () => Text(
                          //           homeController.saldoCad.value,
                          //           style: TextStyle(
                          //               color: getXSwitchState.textMeusCads.value == true
                          //                   ? Get.theme.primaryColor
                          //                   : Colors.white,
                          //               fontSize: 45),
                          //         ),
                          //       ),
                          //     ),
                          //     const Expanded(child: Divider(color: Colors.white)),
                          //   ],
                          // ),
                          const SizedBox(height: 10),

                          // ---------- SEU CARD ESTACIONADO ----------
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: Get.size.width,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              child: Card(
                                elevation: 10,
                                color: appTema.cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Contador
                                      Container(
                                        height: Get.height / 4,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Visibility(
                                          visible: homeController
                                              .isEstacionado.value,
                                          replacement: Contador(
                                            texto: "Sem Estacionamento Ativo",
                                            duracao: 0,
                                          ),
                                          child: Contador(
                                            key: homeController.countDownKey,
                                            Initduracao: contador.value,
                                            texto: "Tempo Restante",
                                            duracao: homeController.dataFim
                                                .difference(
                                                    homeController.dataInicio)
                                                .inSeconds,
                                          ),
                                        ),
                                      ),

                                      // Dados do estacionamento
                                      BodyCard(
                                        dataFim: homeController
                                            .historicoInfo.dataFim!.value,
                                        dataInicio: homeController
                                            .historicoInfo.dataInicio!.value,
                                        isEstacionado:
                                            homeController.isEstacionado.value,
                                        localEstacionado: homeController
                                            .historicoInfo
                                            .localEstacionado!
                                            .value,
                                        localchaveAutenticacao: homeController
                                            .historicoInfo
                                            .localchaveAutenticacao!
                                            .value,
                                        placa: homeController
                                            .historicoInfo.placa!.value,
                                        regra: homeController
                                            .historicoInfo.regra!.value,
                                        startContador: contador.value,
                                      ),

                                      // Botões
                                      Visibility(
                                        visible:
                                            homeController.isEstacionado.value,
                                        replacement: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 20),
                                          child: ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.white,
                                            ),
                                            style: _salvarButtonStyle(),
                                            label: const AutoSizeText(
                                              "Estacionar",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white),
                                            ),
                                            onPressed: botaoEstacionarFuncao,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(Icons.alarm,
                                                      size: 20,
                                                      color: Colors.white),
                                                  style:
                                                      _AdcionarHoraButtonStyle(),
                                                  label: const Text(
                                                    "Estender",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () =>
                                                      botaoRenovarEstacionamentoFuncao(
                                                          context),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(Icons.close,
                                                      size: 20,
                                                      color: Colors.white),
                                                  label: const Text(
                                                    "Cancelar",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  style:
                                                      _AdcionarHoraButtonStyle(
                                                          isAddHora: false),
                                                  onPressed:
                                                      _encerrarEstacionador,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }

  // Once the data is available, build your UI with it.

  void _encerrarEstacionador() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: const Text("Confirmar Cancelamento"),
          content:
              const Text("Tem certeza que deseja cancelar o estacionamento?"),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
                shadowColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black12, width: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
                shadowColor: Colors.black,
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                var retorno = await estacionarController.cancelarEstacioname();
                if (retorno != null) {
                  homeController.startContador.value = 0;
                  historicoController.finalTime.value = true;

                  //-------------------------------------------------------------
                  homeController.isEstacionado.value = false;

                  historicoController.botaoEstacionarHabilitado.value = false;
                  homeController.historicoInfo.placa!.value = '';

                  homeController.historicoInfo.regra!.value = '';

                  homeController.historicoInfo.regra!.value = '';

                  homeController.historicoInfo.tempoDeEstacionamento!.value =
                      '0';

                  homeController.historicoInfo.dataInicio!.value = '';

                  homeController.historicoInfo.dataFim!.value = '';

                  homeController.historicoInfo.localEstacionado!.value = '';
                  Get.back();
                  Get.snackbar("Estacionamento Cancelado", "Estacionamento",
                      colorText: Colors.white,
                      backgroundColor: errorColor,
                      duration: const Duration(seconds: 5));
                } else {}
              },
              child: const Text("Confirmar",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  _salvarButtonStyle() {
    //estilo do botao cadastrar
    return ElevatedButton.styleFrom(
      // backgroundColor: Get.theme.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      padding: const EdgeInsets.all(12),
    );
  }

  ButtonStyle _AdcionarHoraButtonStyle({bool isAddHora = true}) {
    return ElevatedButton.styleFrom(
      backgroundColor: isAddHora
          ? successColor // azul claro
          : const Color(0xFFF44336), // vermelho
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      padding: const EdgeInsets.all(12),
      elevation: 3,
    );
  }

  botaoEstacionarFuncao() async {
    // await FuncoesParaAjudar.recuperaPosition();
    if (homeController.saldoCad.value == "null") {
      Get.snackbar(
          "Erro ao verificar Saldo CAD", "Faça login novamente para recarregar",
          colorText: Colors.white,
          backgroundColor: errorColor,
          duration: const Duration(seconds: 5));
    } else {
      Get.toNamed(Routes.ESTACIONAR);
    }
  }

  void botaoRenovarEstacionamentoFuncao(context) {
    // set up the buttons
    Widget cancelarButton = TextButton(
      child: const Text("Cancelar"),
      onPressed: () {
        print("CANCELADO RENOVAÇAO");
        Get.back();
      },
    );
    Widget continuarButton = TextButton(
      child: const Text("Confirmar"),
      onPressed: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const SimpleDialog(
                backgroundColor: Colors.transparent,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  )
                ],
              );
            });

        if (estacionarController.verificarSaldoCAD() == true) {
          homeController.startContador.value = 0;
          await estacionarController.renovar(
            homeController.historicoInfo.localchaveAutenticacao!.value,
          );
          homeController.startContador.value =
              Storagerds.boxTimer.read('timer');
          print("confirmado renovar");

          //PREENCHE CARD//
          homeController.startContador.value =
              Storagerds.boxTimer.read('timer');
          homeController.historicoInfo.placa!.value =
              Storagerds.boxEstacionado.read('placa');
          homeController.historicoInfo.valor!.value =
              Storagerds.boxEstacionado.read('valor');
          homeController.historicoInfo.regra!.value =
              Storagerds.boxEstacionado.read('regra');
          homeController.historicoInfo.regra!.value =
              Storagerds.boxEstacionado.read('regraDescricao');
          homeController.historicoInfo.localchaveAutenticacao!.value =
              Storagerds.boxEstacionado.read('chaveAutenticacao');
          homeController.historicoInfo.tempoDeEstacionamento!.value = Storagerds
              .boxEstacionado
              .read('tempoDeEstacionamento')
              .toString();
          homeController.historicoInfo.dataInicio!.value =
              Storagerds.boxEstacionado.read('dataInicio');
          homeController.historicoInfo.dataFim!.value =
              Storagerds.boxEstacionado.read('dataFim');
          homeController.historicoInfo.localEstacionado!.value =
              Storagerds.boxEstacionado.read('localCard').toString();
          homeController.historicoInfo.regraDesc!.value =
              Storagerds.boxEstacionado.read("regraDescricao");
// INICIA O TIMER
          homeController.startContador.value =
              Storagerds.boxTimer.read('timer');

          Future.delayed(const Duration(seconds: 2), () {
            Get.offAllNamed(Routes.HOME);
            Get.back();
          });
        } else {
          Get.snackbar(
            "Não foi possivel renovar",
            "Saldo CAD insuficiente",
            colorText: Colors.white,
            backgroundColor: errorColor,
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          );
          Future.delayed(const Duration(seconds: 3), () => Get.back());
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Image.asset(
            "assets/notificationLargeIcon.png",
            height: 40,
            width: 40,
          ),
          const Text("Atenção"),
        ],
      ),
      content: const Text("Você confirma a renovação do estacionamento?"),
      actions: [
        cancelarButton,
        continuarButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> reloadList({bool reloadREgra = false}) async {
    try {
      // homeController.cidade.value = "Buscando localidade...";
      // historicoController.countDownKey =  GlobalKey();
      await homeController.loadCadsaldoApi();
      if (reloadREgra) {
        await Get.find<EstacionarController>().loadRegras(1);
      }
      await homeController.loadingHomeINici();
      //await FuncoesParaAjudar.recuperaPosition();
    } on Exception {
      Get.snackbar("Erro", "Servidor temporariamente indisponível",
          backgroundColor: errorColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 3));
    }
  }
}
