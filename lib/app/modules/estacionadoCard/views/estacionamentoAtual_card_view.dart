import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/modules/home/views/widgets/componentsBody/contador.dart';

import '../controllers/estacionamentoAtual_card_controller.dart';

class EstacionadoAtualCardView
    extends GetView<EstacionamentoAtualCardController> {
  Contador? timer;
  RxString? placa = "".obs;
  RxString? valor = "".obs;
  RxString? regra = "".obs;
  RxString? tempoDeEstacionamento = "".obs;

  RxString? dataHoraInicio = "".obs;
  RxString? dataHoraFim = "".obs;
  //String? local; //endereço por extenso

  EstacionadoAtualCardView({super.key, 
    this.timer,
    this.placa,
    this.valor,
    this.regra,
    this.tempoDeEstacionamento,
    this.dataHoraInicio,
    this.dataHoraFim,
    // this.local
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Tempo Restante",
                style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 130,
                child: Contador(
                 // initialDuration: 0,
                    duracao: timer!.duracao,
                    onInicio: timer!.onInicio,
                    onCompleto: timer!.onCompleto),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Placa: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(homeController.placaEstacionamentoAtual.value),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Valor: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("R\$ ${homeController.valorEstacionamentoAtual.value}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Ativação: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(homeController.dataInicioEstacionamentoAtual.value),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Regra: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(homeController.regraEstacionamentoAtual.value),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Tempo de estacionamento: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(homeController
                      .tempoDeEstacionamentoEstacionamentoAtual.value),
                ],
              ),
            ),
            /*  Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Local: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(local!)
                  ],
                ),
              ), */
          ],
        ),
      ),
    );
  }
}
