import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zona_azul/app/data/global/format_txt.dart';
import 'package:zona_azul/app/modules/home/bindings/home_binding.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

import '../controllers/cadastro_veiculo_controller.dart';

VeiculoController veiculoController = Get.put(VeiculoController());

class CadastroVeiculoView extends GetView<VeiculoController> {
  final _chaveFormularioVeic = GlobalKey<FormState>();
  var myControllerPlaca = TextEditingController();
  var myControllerMarcaModelo = TextEditingController();

  CadastroVeiculoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _chaveFormularioVeic,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cadastrar Veiculo"),
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
                () => TextButton.icon(
                  icon: veiculoController.urlImageButton.value ==
                          "assets/icons/car.png"
                      ? const Icon(
                          Icons.drive_eta,
                          size: 50,
                          color: Colors.black,
                        )
                      : const Icon(Icons.directions_bus,
                          size: 50, color: Colors.black),
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
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
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
              onSubmit: (x) {
                FuncoesParaAjudar.logger.d(x);
              },
              suggestions: listaModeloVeiculo
                  .map((e) => SearchFieldListItem(e, child: Text(e)))
                  .toList(),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Obx(
                () => Visibility(
                  visible: !controller.loading.value,
                  child: ElevatedButton(
                      style: _salvarButtonStyle(),
                      onPressed: () {
                        controller.loading.value = true;
                        print("salvar");
                        var formValidVeic =
                            _chaveFormularioVeic.currentState?.validate() ??
                                false;
                        if (formValidVeic == true) {
                          controller.placaTextController =
                              myControllerPlaca.text;
                          controller.modeloTextController =
                              myControllerMarcaModelo.text;
                          controller.cadastrar();
                        }
                      },
                      child: const Text(
                        'SALVAR',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Obx(
                () => Visibility(
                  visible: controller.loading.value,
                  child: ElevatedButton(
                      style: _salvarButtonStyle(),
                      onPressed: () {},
                      child: const SizedBox(
                          height: 30, child: CircularProgressIndicator())),
                ),
              ),
            ),
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
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ônibus/caminhão"),
                        Icon(Icons.directions_bus,
                            size: 50, color: Colors.black),
                      ],
                    ),
                    value: "ônibus/caminhão",
                    groupValue: veiculoController.tipoDeVeiculo.value,
                    onChanged: (valor) {
                      veiculoController.titleTextButton.value =
                          "ônibus/caminhão";
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

_titleButton() {
  return Text(
    veiculoController.titleTextButton.value,
    style: const TextStyle(fontSize: 30, color: Colors.black87),
  );
}
List<String> listaModeloVeiculo = [
  'Chevrolet Onix',
  'Hyundai HB20',
  'Chevrolet Onix Plus',
  'Fiat Strada',
  'Volkswagen Gol',
  'Ford Ka',
  'Fiat Argo',
  'Volkswagen T-Cross',
  'Jeep Renegade',
  'Fiat Toro',
  'Jeep Compass',
  'Renault Kwid',
  'Chevrolet Tracker',
  'Hyundai Creta',
  'Fiat Mobi',
  'Volkswagen Polo',
  'Toyota Corolla',
  'Nissan Kicks',
  'Honda HR-V',
  'Toyota Hilux',
  'Volkswagen Saveiro',
  'Volkswagen Virtus',
  'Chevrolet S10',
  'Renault Sandero',
  'Ford Ka Sedan',
  'Volkswagen Voyage',
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
  'Chevrolet Cruze',
  'Volkswagen Up',
  'Toyota Yaris Sedan',
  'Citroën C4 Cactus',
  'Peugeot 208',
  'Toyota Hilux SW4',
  'Volkswagen Golf',
  'Fiat Doblo',
  'Kia K2500',
  'Citroën C3',
  'Chevrolet Montana',
  'Kia Sportage',
  'Mitsubishi Outlander',
  'Peugeot 2008',
  'BMW Série 3',
  'Toyota Etios',
  'BMW Série 1',
  'Volkswagen Jetta',
  'Toyota Etios Sedan',
  'Citroën Aircross',
  'Citroën Jumpy',
  'Mercedes-Benz Classe C',
  'Peugeot 3008',
  'Ford Fusion',
  'Kia Picanto',
  'Audi A3 Sedan',
  'BMW X1',
  'Land Rover Range Rover Evoque',
  'Nissan March',
  'Honda City',
  'Audi Q3',
  'Renault Master',
  'Volkswagen Fusca',
  'Hyundai Tucson',
  'JAC T40',
  'JAC T50',
  'BMW X3',
  'Volkswagen Virtus GTS',
  'Suzuki Jimny',
  'BMW X2',
  'Mitsubishi Pajero',
  'Renault Kiger',
  'Audi A1 Sportback',
  'JAC T60',
  'BMW X5',
  'Land Rover Range Rover Velar',
  'Nissan Sentra',
  'Volkswagen Golf Variant',
  'Audi Q5',
  'Hyundai Creta STC',
  'JAC T8',
  'Kia Rio',
  'Lexus NX',
  'Audi A4 Sedan',
  'BMW X6',
  'Mercedes-Benz GLA',
  'Land Rover Range Rover Sport',
  'Volkswagen Tiguan',
  'JAC T6',
  'Volvo XC40',
  'Hyundai Venue',
  'Kia Cerato',
  'Toyota RAV4',
  'Lexus UX',
  'Peugeot 408',
  'Audi Q7',
  'Land Rover Defender',
  'Nissan Leaf',
  'Hyundai Santa Fe',
  'Kia Seltos',
  'Volvo XC60',
  'Toyota Prius',
  'Mercedes-Benz GLB',
  'JAC T5',
  'Kia Carnival',
  'Peugeot 5008',
  'Volvo XC90',
  'Lexus RX',
  'Kia Optima',
  'Land Rover Discovery Sport',
  'Volvo XC60 T8',
  'Lexus CT',
  'Mitsubishi Eclipse Cross',
  'Audi A5 Sportback',
  'Mercedes-Benz GLC',
  'Volvo S60',
  'Toyota Camry',
  'Hyundai Santa Fe 7 Lugares',
  'JAC T80',
  'Kia Soul EV',
  'Land Rover Range Rover',
  'Volvo S90',
  'JAC VUC',
  'Mercedes-Benz Classe E',
  'BMW Série 5',
  'Peugeot 3008 Hybrid',
  'Volvo XC60 T6',
  'Volvo XC90 T8',
  'JAC iEV40',
  'Audi A6',
  'Hyundai Elantra',
  'Kia Sorento',
  'BMW Série 2 Gran Coupé',
  'Kia K5',
  'Volvo XC40 T5',
  'Lexus ES',
  'Mercedes-Benz Classe S',
  'JAC T60 EV',
  'BMW Série 4 Gran Coupé',
  'Hyundai Santa Cruz',
  'JAC iEV20',
  'Kia Niro',
  'Volvo V60',
  'BMW Série 6 Gran Turismo',
  'Volvo XC90 T6',
  'Lexus LS',
  'Volvo V90',
  'Kia Stinger',
  'JAC iEV330P',
  'BMW Z4',
  'Volvo V60 Cross Country',
  'JAC iEV1200T',
  'Volvo S60 T8',
  'BMW Série 8 Gran Coupé',
  'Volvo V60 T8',
  'Volvo V90 Cross Country',
  'Volvo S90 T8',
  'Volvo V60 Cross Country T8',
  'Volvo V90 Cross Country T8',
  'Volvo XC60 T8 Polestar Engineered',
  'Volvo XC90 T8 Polestar Engineered',
];

_salvarButtonStyle() {
  //estilo do botao cadastrar
  return ElevatedButton.styleFrom(
    //primary: Color.fromARGB(255, 129, 212, 250),
    //backgroundColor: const Color(0xFFffcc43),
    //onPrimary: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    padding: const EdgeInsets.all(12),
  );
}
