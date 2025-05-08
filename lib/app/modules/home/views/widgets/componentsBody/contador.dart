import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';

class Contador extends GetView<HistoricoController> {
  final int duracao;
  final int? Initduracao;
  final String? texto;
  final VoidCallback? onInicio;
  final VoidCallback? onCompleto;
  final boxEstacionado = GetStorage("boxEstacionado");
  final boxbotaoEstacionarHabilitado =
      GetStorage("boxbotaoEstacionarHabilitado");

  Contador(
      {super.key,
      required this.duracao,
      this.Initduracao = 0,
      this.texto,
      this.onInicio,
      this.onCompleto});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    // Adiciona o widget de texto se 'texto' não for nulo
    if (texto != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(
            texto!,
            maxLines: 1,
            style: const TextStyle(
              color: Color(0xFF6B7280) // cinza médio puxado para o neutro
              ,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    // Adiciona o widget CircularCountDownTimer
    children.add(
      Expanded(
        child: CircularCountDownTimer(
          ringColor: Colors.grey,
          width: Get.width,
          height: Get.height,
          duration: duracao,
          initialDuration: Initduracao!,
          fillColor: Get.theme.primaryColor,
          controller: controller.countDownController,
          backgroundColor: Colors.white54,
          strokeWidth: 15,
          strokeCap: StrokeCap.round,
          isTimerTextShown: true,
          isReverse: true,
          onStart: onInicio,
          onComplete: () {
            print("close");
          },
          textStyle: TextStyle(fontSize: 30, color: Get.theme.primaryColor),
        ),
      ),
    );

    // Retorna a Column com os widgets
    return Column(
      spacing: 4,
      children: children,
    );
  }
}
