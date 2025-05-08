import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:zona_azul/app/data/models/historicoLog.dart';
import 'package:zona_azul/app/modules/historico/views/widgets/pdfexport.dart';


Future<Uint8List> makePdfLog(LogPagamento logPagamento) async {
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
                      'Log Pagamento ID:',
                      align: TextAlign.center,
                    ),
                    PaddedText(
                      "${logPagamento.logPagamentoID}",
                      align: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    PaddedText('Valor Pago:', align: TextAlign.center),
                    PaddedText(
                      "${logPagamento.valorpago}",
                      align: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    PaddedText('CPF/CNPJ:', align: TextAlign.center),
                    PaddedText(
                      "${logPagamento.cpfcnpj}",
                      align: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    PaddedText('Qtd de Cads:', align: TextAlign.center),
                    PaddedText(
                      "${logPagamento.qtdcad}",
                      align: TextAlign.center,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    PaddedText('Data Pagamento:', align: TextAlign.center),
                    PaddedText(
                      "${DateFormat("dd/MM/yyyy HH:mm:ss").format(logPagamento.dataPagamento!)}",
                      align: TextAlign.center,
                    ),
                  ],
                ),
                // Adicione mais linhas para outros campos do log de pagamento, se necessário
              ],
            ),
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
