import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/theme/tema.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

import '../../home/controllers/GetXSwitchState.dart';
import '../controllers/configuracoes_controller.dart';

class ConfiguracoesView extends GetView<ConfiguracoesController> {
  const ConfiguracoesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool showAppBar = Get.arguments ?? false;
    final controleconfigure = Get.put(ConfiguracoesController());

    final alertaSelecionado = homeController.alertaSelecionado;
    final valorAlertaSelecionado = homeController.valorAlertaSelecionado;
    final exibirTelaIntroducao = homeController.exibirTelaIntroducao;

    if (Storagerds.boxvalorAlertaSelecionado
            .read('boxvalorAlertaSelecionado') ==
        1200) {
      alertaSelecionado.value = true;
      valorAlertaSelecionado.value = 1200;
    } else {
      valorAlertaSelecionado.value = 600;
    }

    exibirTelaIntroducao.value =
        Storagerds.boxExibirTelaIntroducao.read('boxExibirTelaIntroducao') ??
            true;

    return SafeArea(
      child: Scaffold(
        appBar: showAppBar
            ? AppBar(
                title: const Text('Configurações de Alerta'),
                centerTitle: true,
              )
            : null,
        body: Obx(
          () => ListView(
            children: [
              buildListTile(
                title: "Alertar 10 minutos antes de expirar",
                value: !alertaSelecionado.value,
                onChanged: (value) {
                  updateAlertaSelecionado(!value, value ? 1200 : 600);
                },
              ),
              buildListTile(
                title: "Alertar 20 minutos antes de expirar",
                value: alertaSelecionado.value,
                onChanged: (value) {
                  updateAlertaSelecionado(value, value ? 1200 : 600);
                },
              ),
              buildListTile(
                title: "Exibir tela de Introdução",
                value: exibirTelaIntroducao.value,
                onChanged: (value) {
                  updateExibirTelaIntroducao(value);
                },
              ),
              buildListTile(
                title: "Exibir Biometria?",
                value: controller.isSwitched.value,
                onChanged: (value) {
                  updateBiometria(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void updateAlertaSelecionado(bool newValue, int valor) {
    homeController.alertaSelecionado.value = newValue;
    homeController.valorAlertaSelecionado.value = valor;
    Storagerds.boxvalorAlertaSelecionado
        .write('boxvalorAlertaSelecionado', valor);
  }

  void updateExibirTelaIntroducao(bool value) {
    homeController.exibirTelaIntroducao.value = value;
    Storagerds.boxExibirTelaIntroducao.write('boxExibirTelaIntroducao', value);
  }

  void updateBiometria(bool value) {
    controller.isSwitched.value = value;
    Storagerds.boxBiometria.write('biometria', value);
  }
}
