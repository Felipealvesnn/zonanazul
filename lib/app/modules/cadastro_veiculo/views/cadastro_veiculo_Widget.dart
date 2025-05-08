import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zona_azul/app/data/global/format_txt.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/controllers/cadastro_veiculo_controllerWidget.dart';
import 'package:zona_azul/app/modules/home/bindings/home_binding.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';

import '../controllers/cadastro_veiculo_controller.dart';

VeiculoControllerWidget veiculoControllerWidget =
    Get.put(VeiculoControllerWidget());

class CadastroVeiculoWidget extends GetView<VeiculoControllerWidget> {
  final _chaveFormularioVeic = GlobalKey<FormState>();
  var myControllerPlaca = TextEditingController();
  var myControllerMarcaModelo = TextEditingController();

  CadastroVeiculoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _chaveFormularioVeic,
      child: SingleChildScrollView(
        child: Column(
          children: [
            //
            //----------------------------------------------<BOTÃO>----------------------------------------------------
            //

            SizedBox(
              height: 40,
              child: Obx(
                () => TextButton.icon(
                  icon: veiculoControllerWidget.urlImageButton.value ==
                          "assets/icons/car.png"
                      ? const Icon(
                          Icons.drive_eta,
                          size: 30,
                          color: Colors.black,
                        )
                      : const Icon(Icons.directions_bus,
                          size: 30, color: Colors.black),
                  label: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _titleButton(),
                        const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.grey[350]),
                  onPressed: () {
                    _selecionaVeiculo(context);
                  },
                ),
              ),
            ),

            //
            //----------------------------------------------</BOTÃO>----------------------------------------------------
            //
            //
            //
            /*   Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                child: Text(
                  "Informe a placa do seu veículo: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black),
                )), */
            //
            ////
            /////------------------------<campo de texto>-----------------------------------------------------
            ///
            ///
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: SizedBox(
                child: TextFormField(
                  validator: Validatorless.required("Placa Obrigatória"),
                  controller: myControllerPlaca,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Placa",

                      // contentPadding:EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      contentPadding: const EdgeInsets.only(
                        left: 12,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      )),
                  inputFormatters: [
                    UpperCaseTxt(),
                    TextInputMask(
                        mask: 'AAA-9N99',
                        placeholder: '_',
                        maxPlaceHolders: 11,
                        reverse: false)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: SizedBox(
                child: SearchField(
                  controller: myControllerMarcaModelo,
                  validator: Validatorless.required("Modelo Obrigatório"),
                  searchStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  // hint: "Modelo do veiculo",

                  suggestions: listaModeloVeiculo
                      .map((e) => SearchFieldListItem(e, child: Text(e)))
                      .toList(),
                  searchInputDecoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Modelo",
                      contentPadding: const EdgeInsets.only(
                        left: 12,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      )),
                ),
              ),
            ),

            //
            ////
            /////------------------------</campo de texto>-----------------------------------------------------

            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  width: 400,
                  child: Obx(() => Visibility(
                        visible: !veiculoControllerWidget.loading.value,
                        child: ElevatedButton(
                            style: _salvarButtonStyle(),
                            onPressed: () {
                              veiculoControllerWidget.loading.value = true;

                              var formValidVeic = _chaveFormularioVeic
                                      .currentState
                                      ?.validate() ??
                                  false;
                              if (formValidVeic == true) {
                                controller.placaTextController =
                                    myControllerPlaca.text;
                                controller.modeloTextController =
                                    myControllerMarcaModelo.text;
                                controller.cadastrar();
                                Future.delayed(const Duration(seconds: 2), () {
                                  myControllerPlaca.clear();
                                  myControllerMarcaModelo.clear();
                                  veiculoControllerWidget.loading.value = false;
                                });
                              }
                            },
                            child: const Text(
                              'SALVAR',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      )),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Obx(() => Visibility(
                      visible: veiculoControllerWidget.loading.value,
                      child: const CircularProgressIndicator(),
                    ))),
          ],
        ),
      ),
    );
  }
}

//-----------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------FUNÇÕES--------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------
void _selecionaVeiculo(context) {
  //final VeiculoController c = Get.put(VeiculoController());
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  // leading: Image.asset("assets/veiculos/celta.png"),
                  title: const Center(
                      child: Text(
                    'Tipo de veículo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  onTap: () => {}),
              Obx(
                () => RadioListTile(
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("carro"),
                        Icon(
                          Icons.drive_eta,
                          size: 50,
                          color: Colors.black,
                        )
                      ],
                    ),
                    value: "carro",
                    groupValue: veiculoControllerWidget.tipoDeVeiculo.value,
                    onChanged: (valor) {
                      veiculoControllerWidget.titleTextButton.value = "Carro";
                      veiculoControllerWidget.urlImageButton.value =
                          "assets/icons/car.png";
                      veiculoControllerWidget.tipoDeVeiculo.value =
                          valor.toString();
                      veiculoControllerWidget.boxtipoVeic.write('tipoVeic',
                          veiculoControllerWidget.tipoDeVeiculo.value);
                      Get.back();
                    }),
              ),
              Obx(
                () => RadioListTile(
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ônibus/caminhão"),
                        Icon(Icons.directions_bus,
                            size: 50, color: Colors.black),
                      ],
                    ),
                    value: "ônibus/caminhão",
                    groupValue: veiculoControllerWidget.tipoDeVeiculo.value,
                    onChanged: (valor) {
                      veiculoControllerWidget.titleTextButton.value =
                          "ônibus/caminhão";
                      veiculoControllerWidget.urlImageButton.value =
                          "assets/icons/bus.png";
                      veiculoControllerWidget.tipoDeVeiculo.value =
                          valor.toString();
                      veiculoControllerWidget.boxtipoVeic.write('tipoVeic',
                          veiculoControllerWidget.tipoDeVeiculo.value);

                      Get.back();
                    }),
              )
            ],
          ),
        );
      });
}

_iconButton() {
  return Image.asset(veiculoControllerWidget.urlImageButton.value);
}

_titleButton() {
  return Text(
    veiculoControllerWidget.titleTextButton.value,
    style: const TextStyle(fontSize: 20, color: Colors.black87),
  );
}

List<String> listaModeloVeiculo = [
  'Chevrolet Onix',
  'Hyundai HB20',
  'Chevrolet Onix Plus'
      'Fiat Strada',
  'Volkswagen Gol',
  'Ford Ka',
  'Fiat Argo'
      'Volkswagen T-Cross',
  'Jeep Renegade',
  'Fiat Toro',
  'Jeep Compass',
  'Renault Kwid',
  'Chevrolet Tracker',
  'Hyundai Creta',
  'Fiat Mobi',
  'Volkswagen Polo',
  'Toyota Corolla'
      'Nissan Kicks',
  'Honda HR-V',
  'Toyota Hilux',
  'Volkswagen Saveiro',
  'Volkswagen Virtus',
  'Chevrolet S10',
  'Renault Sandero',
  'Ford Ka Sedan',
  'Volkswagwagen Voyage',
  'Ford EcoSport',
  'Hyundai HB20S',
  'Fiat Uno',
  'Toyota Yaris Hatch',
  'Honda Civic',
  'Volkswagen Fox',
  'Ford Ranger',
  'Renault Duster',
  'Fiat Fiorino',
  'Volkswagen Nivus',
  'Fiat Cronos',
  'Chevrolet Spin',
  'Renault Logan',
  'Honda Fit',
  'Nissan Versa',
  'Toyota SW4',
  'Renault Captur',
  'Fiat Grand Siena',
  'Volkswagen Amarok',
  'Honda WR-V',
  'Mitsubishi L200',
  'Chevrolet Cruze'
];

_salvarButtonStyle() {
  //estilo do botao cadastrar
  return ElevatedButton.styleFrom(
    //primary: Color.fromARGB(255, 129, 212, 250),
    backgroundColor: const Color(0xFFffcc43),
    //onPrimary: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    padding: const EdgeInsets.all(12),
  );
}
