import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zona_azul/app/data/global/format_txt.dart';
import 'package:zona_azul/app/data/models/historicoLog.dart';
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/modules/comprar_cad_semBarr.dart/comprar_cad_view_semBarr.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';
import 'package:zona_azul/app/modules/historico/views/widgets/PdfPreviewPage.dart';
import 'package:zona_azul/app/modules/historico/views/widgets/DateRangePickerDialog.dart';
import 'package:zona_azul/app/data/global/constants.dart';

class HistoricoViewSemBarra extends StatelessWidget {
  final HistoricoController historicoController =
      Get.find<HistoricoController>();
  final TextEditingController editingController = TextEditingController();

  HistoricoViewSemBarra({super.key});

  @override
  Widget build(BuildContext context) {
    if (historicoController.historicoLoglist.isEmpty) {
      reloadList();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: buildSearchBar(),
        centerTitle: false,
        actions: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.print,
          //   ),
          //   onPressed: () {
          //     Get.to(
          //       () => PdfPreviewPage(
          //         historicoLog: historicoController.historicoLoglist,
          //       ),
          //     );
          //   },
          // ),
          IconButton(
            icon: const Icon(
              Icons.calendar_month,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DateRangePickerDialogHisto(
                    controller: historicoController,
                  ); // Exibe o modal
                },
              );
            },
          ),
        ],
      ),
      body: Obx(
        () => RefreshIndicator(
          edgeOffset: double.parse(Get.height.toString()) * 0.1,
          displacement: 90,
          backgroundColor: Colors.white,
          onRefresh: reloadList,
          child: Center(
            child: buildHistoricoList(),
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return SizedBox(
      height: 38,
      child: TextField(
        inputFormatters: [
          UpperCaseTxt(),
          TextInputMask(
            mask: 'AAA-9N99',
            placeholder: '_',
            maxPlaceHolders: 11,
            reverse: false,
          ),
        ],
        onChanged: (valor) {
          if (valor == '___-____') {
            editingController
                .clear(); // Limpa o campo quando o valor estiver vazio
            historicoController.searchTitle.value = '';
          } else {
            historicoController.searchTitle.value = valor;
          }
        },
        onSubmitted: (valor) {
          if (valor == '___-____') {
            editingController
                .clear(); // Limpa o campo quando o valor estiver vazio
            historicoController.searchTitle.value = '';
          } else {
            historicoController.searchTitle.value = valor;
          }
        },
        controller: editingController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade700),
          contentPadding: const EdgeInsets.all(0),
          filled: true,
          fillColor: Colors.grey[300],
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          hintStyle: const TextStyle(fontSize: 14),
          hintText: "Filtrar placa...",
        ),
      ),
    );
  }

  Widget buildHistoricoList() {
    if (historicoController.isloadingPageHitory.value) {
      return const Center(child: ShimmerLoadingList());
    }

    return Visibility(
        visible: historicoController.historicoLoglist.isNotEmpty,
        replacement: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: const [
                  Center(child: Text('Nenhum histórico')),
                ],
              ),
            ),
          ],
        ),
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 20),
          itemCount: historicoController.historicoLoglist.length,
          itemBuilder: (context, index) {
            HistoricoLog lista = historicoController.historicoLoglist[index];

            // Verifica se é um registro de estacionamento
            if (lista.tipo!.toUpperCase() == "estacionamento".toUpperCase()) {
              HistoricoEstacionamento estacionamento = lista.estacionamento!;

              return ListTile(
                iconColor: Get.theme.primaryColor,
                leading: const Icon(Icons.location_on_outlined),
                trailing: const Icon(Icons.mark_email_read_outlined),
                title: Text(estacionamento.placa.toString()),
                subtitle: estacionamento.horarioCancelado == null
                    ? Text(
                        "${DateFormat("'Inicio:' dd/MM/yyyy HH:mm:ss").format(estacionamento.dataHoraInicio!)}\n"
                        "${DateFormat("'Fim:' dd/MM/yyyy HH:mm:ss").format(estacionamento.dataHoraFim!)}\n"
                        "local: ${estacionamento.local}",
                      )
                    : Text(
                        "${DateFormat("'Inicio:' dd/MM/yyyy HH:mm:ss").format(estacionamento.dataHoraInicio!)}\n"
                        "${DateFormat("'Cancelado em:' dd/MM/yyyy HH:mm:ss").format(estacionamento.horarioCancelado!)}\n"
                        "local: ${estacionamento.local}",
                      ),
                isThreeLine: true,
                onTap: () async {
                  await Get.to(() => PdfPreviewPage(historico: estacionamento));
                },
              );
            }
            // Verifica se é um registro de pagamento
            else if (lista.tipo!.toUpperCase() == "compra".toUpperCase()) {
              LogPagamento pagamento = lista.pagamento!;
              return ListTile(
                iconColor: Get.theme.primaryColor,
                leading: const Icon(Icons.monetization_on_outlined),
                trailing: const Icon(Icons.mark_email_read_outlined),
                title: Text("Pagamento"),
                subtitle: Text(
                  "Valor pago: ${pagamento.valorpago}\n"
                  "Data do pagamento: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(pagamento.dataPagamento!)}\n"
                  "Qtd de Cads: ${pagamento.qtdcad}",
                ),
                isThreeLine: true,
                onTap: () async {
                  await Get.to(() => PdfPreviewPage(logPagamento: pagamento));
                },
              );
            } else {
              // Lidar com outro tipo de registro, se necessário
              return Container();
            }
          },
        ));
  }

  void confirmacaoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Atenção"),
          content: const Text("Você fazer o envio deste historico por email?"),
          actions: [
            TextButton(
              child: Text("Cancelar", style: TextStyle(color: errorColor)),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child:
                  const Text("Confirmar", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                // Execute ação de confirmação aqui
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> reloadList() async {
    try {
      historicoController.isloadingPageHitory.value = true;
      //await Get.find<HomeController>().loadUltimoHistoricoEstacionamento();
      await historicoController.carregarHistorioElog();
      historicoController.isloadingPageHitory.value = false;
    } catch (e) {
      Get.snackbar(
        "Erro",
        "Erro ao carregar histórico: $e",
        backgroundColor: errorColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
