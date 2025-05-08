import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:zona_azul/app/data/models/Setor.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class CUstomRadioButton extends StatelessWidget {
  final EstacionarController estacionarController;

  const CUstomRadioButton({super.key, required this.estacionarController});
  @override
  Widget build(BuildContext context) {
    return CustomRadioButton(
      enableShape: true,
      shapeRadius: 30,
      radius: 30,
      //defaultSelected: "1",
      defaultSelected:
          "${Storagerds.boxCustomRadioCartoesValue.read('boxCustomRadioCartoesValue') ?? "1"}",
      height: 45,
      width: 150,
      elevation: 0,
      absoluteZeroSpacing: false,

      unSelectedColor: const Color.fromARGB(255, 255, 254, 254),
      buttonLables: const [
        '1 Cartão',
        '2 Cartões',
      ],
      buttonValues: const [
        "1",
        "2",
      ],
      buttonTextStyle: const ButtonTextStyle(
          selectedColor: Colors.white,
          unSelectedColor: Colors.black,
          textStyle: TextStyle(fontSize: 14)),
      radioButtonValue: (value) async {
        estacionarController.SetorSelecionado = null;
        estacionarController.carregando.value == false;
        //estacionarController.resetSelecao();
        await Storagerds.boxCustomRadioCartoesValue
            .write('boxCustomRadioCartoesValue', value);
        if (await estacionarController.testarGpsLigado()) {
          await estacionarController.recuperaCurrentPosition();
        } else {
          estacionarController.setor = Setor();
          await estacionarController.loadRegras(int.tryParse(value)!);
        }
        estacionarController.buttonCartaoSelected.value = value.toString();
         estacionarController.FiltrarRegraEstacionamento(int.parse(value));
        estacionarController.carregando.value == true;

        //estacionarController.validarCampos2();
      },
      selectedColor: Get.theme.primaryColor,
    );
  }
}
