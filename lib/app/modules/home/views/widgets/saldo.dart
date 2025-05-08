import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class Saldo extends GetView<HomeController> {
  //final boxsaldo = GetStorage('saldo');
  @override
  Widget build(BuildContext context) {
    controller.saldoCad.value = Storagerds.boxSaldo.read('saldo').toString();
    var user = Storagerds.boxUserLogado.read('boxUserLogado');
    return Obx(() => Text(
          controller.saldoCad.value == null
              ? "nulo"
              : controller.saldoCad.value,
          style: TextStyle(color: Colors.white, fontSize: 45),
        ));
  }
}
