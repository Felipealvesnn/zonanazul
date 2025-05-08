import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zona_azul/app/data/global/format_txt.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

import '../controllers/cadastro_veiculo_controller.dart';

VeiculoController veiculoController = Get.put(VeiculoController());
HomeController homeController = HomeController();

class EditarVeiculoView extends GetView<VeiculoController> {
  final _chaveFormularioVeic = GlobalKey<FormState>();
  TextEditingController myControllerPlaca = TextEditingController();
  TextEditingController myControllerMarcaModelo = TextEditingController();

  String? placa;
  String? marca;
  String? tipoVeiculo;
  String? cpf;
  String? token;
/* 
  EditarVeiculoView(
      this.placa, this.marca, this.tipoVeiculo, this.cpf, this.token); */

  EditarVeiculoView(
      {super.key,
      this.placa,
      this.marca,
      this.tipoVeiculo,
      this.cpf,
      this.token});

  //RxString edittitleTextButton = "carro".obs;

  @override
  Widget build(BuildContext context) {
    var myControllerPlaca = TextEditingController(text: placa.toString());
    var myControllerMarcaModelo = TextEditingController(text: marca.toString());
    return Form(
      key: _chaveFormularioVeic,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text("Editar Veiculo"),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10, right: 12, left: 12),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 12),
              child: Text(
                "Tipo de veículo: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
            //
            //----------------------------------------------<BOTÃO>----------------------------------------------------
            //

            SizedBox(
              height: 100,
              child: Obx(
                () => TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    _selecionaVeiculo(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _iconButton(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              veiculoController.titleTextButton.value,
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.black87),
                            ),
                          ),
                        ],
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

            //
            //----------------------------------------------</BOTÃO>----------------------------------------------------
            //
            //
            //
            const Padding(
                padding: EdgeInsets.only(top: 12.0, bottom: 12),
                child: Text(
                  "Qual a placa do seu veículo: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                )),
            //
            ////
            /////------------------------<campo de texto>-----------------------------------------------------
            ///
            ///
            SizedBox(
              child: TextFormField(
                validator: Validatorless.required("Placa Obrigatória"),
                controller: myControllerPlaca,
                style: const TextStyle(fontSize: 50),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    // hintText: "Placa",

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
            const SizedBox(
              height: 10,
            ),

            //
            ////
            /////------------------------</campo de texto>-----------------------------------------------------
            ///
            ///
            const Padding(
                padding: EdgeInsets.only(top: 12.0, bottom: 12),
                child: Text(
                  "Modelo do veículo: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                )),
            const SizedBox(
              height: 10,
            ),
            SearchField(
              controller: myControllerMarcaModelo,
              validator: Validatorless.required("Modelo Obrigatório"),
              searchStyle: const TextStyle(
                fontSize: 30,
              ),
              hint: "Modelo do veiculo",

              //suggestionState: SuggestionState.enabled,
              suggestions: listaModeloVeiculo
                  .map((e) => SearchFieldListItem(e, child: Text(e)))
                  .toList(),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Obx(() => Visibility(
                      visible: !veiculoController.loadingUpdate.value,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //primary: Color.fromARGB(255, 129, 212, 250),
                            backgroundColor: const Color(0xFFffcc43),
                            //onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            padding: const EdgeInsets.all(12),
                          ),
                          onPressed: () async {
                            var formValidVeic =
                                _chaveFormularioVeic.currentState?.validate() ??
                                    false;
                            if (formValidVeic == true) {
                              veiculoController.loadingUpdate.value = true;
                              veiculoController.placaTextController =
                                  myControllerPlaca.text;
                              veiculoController.modeloTextController =
                                  myControllerMarcaModelo.text;
                              //controller.cadastrar();
                              await veiculoController
                                  .updateVeiculoImprovisado();
                              veiculoController.loadingUpdate.value = false;
                            } else {
                              veiculoController.loadingUpdate.value = false;
                            }
                          },
                          child: const Text(
                            'ATUALIZAR',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                    ))),

            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Obx(
                  () => Visibility(
                    visible: veiculoController.loadingUpdate.value,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //primary: Color.fromARGB(255, 129, 212, 250),
                          backgroundColor: const Color(0xFFffcc43),
                          //onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          padding: const EdgeInsets.all(12),
                        ),
                        onPressed: () {},
                        child: const SizedBox(
                            height: 30, child: CircularProgressIndicator())),
                  ),
                )),
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
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
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
                    title: const Text("carro"),
                    value: "carro",
                    groupValue: veiculoController.tipoDeVeiculo.value,
                    onChanged: (valor) {
                      veiculoController.titleTextButton.value = "Carro";
                      veiculoController.urlImageButton.value =
                          "assets/icons/car.png";
                      veiculoController.tipoDeVeiculo.value = valor.toString();
                      Storagerds.boxtipoVeic.write(
                          'tipoVeic', veiculoController.tipoDeVeiculo.value);
                      Get.back();
                    }),
              ),
              Obx(
                () => RadioListTile(
                    title: const Text("caminhao/ônibus"),
                    value: "caminhao/ônibus",
                    groupValue: veiculoController.tipoDeVeiculo.value,
                    onChanged: (valor) {
                      veiculoController.titleTextButton.value =
                          "caminhao/ônibus";

                      veiculoController.urlImageButton.value =
                          "assets/icons/bus.png";
                      veiculoController.tipoDeVeiculo.value = valor.toString();
                      Storagerds.boxtipoVeic.write(
                          'tipoVeic', veiculoController.tipoDeVeiculo.value);

                      Get.back();
                    }),
              )
            ],
          ),
        );
      });
}

/* _tipoVeicButton() {
  if (veiculoController.boxtipoVeic.read("tipoVeic") == "carro") {
    veiculoController.urlImageButton.value = "assets/icons/car.png";
    veiculoController.titleTextButton.value = "carro";
  } else {
    veiculoController.urlImageButton.value = "assets/icons/bus.png";
    veiculoController.titleTextButton.value = "carro";
  }
} */

_iconButton() {
  return Image.asset(veiculoController.urlImageButton.value);
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
    backgroundColor: Colors.deepOrange,
    //onPrimary: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    padding: const EdgeInsets.all(12),
  );
}

_titleButton() {
  return Text(
    veiculoController.titleTextButton.value,
    style: const TextStyle(fontSize: 30, color: Colors.black87),
  );
}
