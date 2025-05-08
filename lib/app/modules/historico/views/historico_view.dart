import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

import '../controllers/historico_controller.dart';

class HistoricoView extends GetView<HistoricoController> {
  HistoricoController historicoController = Get.find<HistoricoController>();
  TextEditingController editingController = TextEditingController();

  HistoricoView({super.key});

  @override
  start() {
    controller.loadHistoricoEstacionamento;
    controller.historico.value =
        Storagerds.boxListHistorico.read('boxListHistorico');
    List<HistoricoEstacionamento> lista = controller.historico.value;
  }

  sair() {
    Get.offAllNamed(Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    try {
      start();
    } catch (error) {
      /*  Get.snackbar("Error", error.toString(),
          colorText: Colors.white, backgroundColor: Colors.red); */
    }

    return PopScope(
      onPopInvoked: (bool) {
        sair();
      },
      child: Scaffold(
        appBar: AppBar(
          //title: Text("Histórico"),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: SizedBox(
            height: 38,
            child: TextField(
              onChanged: (valor) =>
                  controller.filtoHistorico(valor.toUpperCase()),
              onSubmitted: (valor) =>
                  controller.filtoHistorico(valor.toUpperCase()),
              controller: editingController,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade700,
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  hintStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  hintText: "Buscar"),
            ),
          ),
          centerTitle: false,
        ),
        body: Obx(
          () => RefreshIndicator(
            onRefresh: reloadList,
            child: controller.historico.isEmpty
                ? ListView(
                    shrinkWrap: true,
                    children:  [
                      SizedBox(
                        height: Get.height * 0.8,
                        width: Get.width ,
                        child: const ListTile(
                          title: Center(
                            child: Text("Nenhum Historico encontrado"),
                          ),
                        ),
                      ),
                    ],
                  )
                : Obx(
                    () => ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                              height: 20,
                            ),
                        itemCount: controller.historico.length,
                        itemBuilder: (context, index) {
                          HistoricoEstacionamento lista =
                              controller.historico[index];
                          DateTime? datainicio =
                              lista.dataHoraInicio;
                          DateTime? datafim =
                            lista.dataHoraFim;
                          return ListTile(
                            iconColor: Get.theme.primaryColor,
                            leading: const Icon(Icons.location_on_outlined),
                            trailing:
                                const Icon(Icons.mark_email_read_outlined),
                            title: Text(lista.placa.toString()),
                            // dense: true,
                            //subtitle: Text("${lista.dataHoraInicio}\n${lista.dataHoraFim}"),
                            subtitle: Text(
                                "${DateFormat("'Inicio:' dd/MM/yyyy HH:mm:ss").format(datainicio!)}\n${DateFormat("'Fim:' dd/MM/yyyy HH:mm:ss").format(datafim!)}\nlocal: ${lista.local}"),
                            isThreeLine: true,
                            onTap: () {
                              confirmacaoDialog(context);
                            },
                          );
                        }),
                  ),
          ),
        ),
      ),
    );
  }

  confirmacaoDialog(BuildContext context) {
    // set up the buttons
    Widget cancelarButton = TextButton(
      child: Text(
        "Cancelar",
        style: TextStyle(color: errorColor),
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget continuarButton = TextButton(
      child: const Text("Confirmar", style: TextStyle(color: Colors.blue)),
      onPressed: () async {
        /*  controller.deletarCartao(numero, cpf, token);
        relod(context); */
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Atenção"),
      content: const Text("Você fazer o envio deste historico por email?"),
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

  Future<void> reloadList() async {
    try {
      controller.loadHistoricoEstacionamento();
    } on Exception {
      Get.snackbar("Erro", "Servidor temporariamente indisponível",
          backgroundColor: errorColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 3));
    }
  }
}
