import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';

Future<Uint8List> makePdf(HistoricoEstacionamento historico) async {
  DateTime? datainicio = historico.dataHoraInicio;
  DateTime? datafim = historico.dataHoraFim;

  final pdf = Document();
  final imageLogo = MemoryImage(
    (await rootBundle.load('assets/flutter.png')).buffer.asUint8List(),
  );
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "E S T A C I O N A   J Á",
                      style: Theme.of(context).header1.copyWith(
                            color: PdfColors.blue,
                          ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(imageLogo),
                )
              ],
            ),
            Container(height: 50),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    PaddedText(
                      'PLACA :',
                      align: TextAlign.center,
                    ),
                    PaddedText(
                      "${historico.placa}",
                      align: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    PaddedText('DATA INICIO:', align: TextAlign.center),
                    PaddedText(
                      "${DateFormat("dd/MM/yyyy HH:mm:ss").format(datainicio!)}\n",
                      align: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    PaddedText('DATA FIM:', align: TextAlign.center),
                    PaddedText(
                      "${DateFormat("dd/MM/yyyy HH:mm:ss").format(datafim!)}\n",
                      align: TextAlign.center,
                    )
                  ],
                ),
                TableRow(
                  children: [
                    PaddedText('DATA FIM:', align: TextAlign.center),
                    PaddedText(
                      "Local: ${historico.local}\n",
                      align: TextAlign.center,
                    )
                  ],
                ),
                TableRow(children: [
                  PaddedText('Regra Cads:', align: TextAlign.center),
                  PaddedText(
                    " ${historico.regraEstacionamento}\n",
                    align: TextAlign.center,
                  )
                ]),
                TableRow(
                  children: [
                    PaddedText('Autentificação:', align: TextAlign.center),
                    PaddedText(
                      " ${historico.chaveAutenticacao}\n",
                      align: TextAlign.center,
                    )
                  ],
                ),
              ],
            ),
            //  Table(
            //   border: TableBorder.all(color: PdfColors.black),
            //   children: [
            //     TableRow(
            //       children: [
            //         PaddedText('DATA FIM:', align: TextAlign.center),
            //         PaddedText(
            //           "${DateFormat("dd/MM/yyyy HH:mm:ss").format(datafim!)}\n",
            //           align: TextAlign.center,
            //         )
            //       ],
            //     ),
            //   ],
            // ),
            Padding(
              child: Text(
                " ",
                style: Theme.of(context).header2,
              ),
              padding: EdgeInsets.all(20),
            ),
            Divider(
              height: 1,
              borderStyle: BorderStyle.dashed,
            ),
            Container(height: 50),

            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'Para maiores informações .....',
                style: Theme.of(context).header3.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        );
      },
    ),
  );
  return pdf.save();
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
