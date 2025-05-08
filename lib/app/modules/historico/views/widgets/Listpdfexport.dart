import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/modules/historico/views/widgets/pdfexport.dart';

import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/modules/historico/views/widgets/pdfexport.dart';

Future<Uint8List> listmakePdf(List<HistoricoEstacionamento> historicos) async {
  final pdf = Document();
  final imageLogo = MemoryImage(
    (await rootBundle.load('assets/flutter.png')).buffer.asUint8List(),
  );

  // Variável para armazenar o total geral
  int totalGeral = 0;

  // Definindo o cabeçalho da página
  Widget _buildHeader(Context context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "E S T A C I O N A   J Á",
                  style: Theme.of(context).header1.copyWith(
                        color: PdfColors.blue,
                      ),
                ),
              ],
            ),
            SizedBox(
              height: 150,
              width: 150,
              child: Image(imageLogo),
            )
          ],
        ),
        Container(
          height: 20,
        ), // Espaço entre o cabeçalho e o conteúdo da página
      ],
    );
  }

  // Definindo o rodapé da página
  Widget _buildFooter(Context context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'Para maiores informações .....',
        textAlign: TextAlign.center,
      ),
    );
  }

  // Função para adicionar uma página com os históricos fornecidos
  void addPageWithHistoricos(
      List<HistoricoEstacionamento> historicos, bool isLastPage) {
    pdf.addPage(
      MultiPage(
        pageTheme: PageTheme(
          buildBackground: (Context context) {
            return Container(); // Evita que o plano de fundo seja desenhado em cada página
          },
        ),
        header: _buildHeader,
        footer: isLastPage
            ? _buildFooter
            : null, // Remova o rodapé exceto na última página
        build: (context) {
          List<TableRow> rows = [];

          for (var historico in historicos) {
            DateTime? datainicio = historico.dataHoraInicio;
            DateTime? datafim = historico.dataHoraFim;

            rows.add(
              TableRow(
                children: [
                  PaddedText('PLACA: "${historico.placa}"',
                      align: TextAlign.center),
                  PaddedText(
                      'DATA INICIO: ${DateFormat("dd/MM/yyyy HH:mm:ss").format(datainicio!)}',
                      align: TextAlign.center),
                  PaddedText(
                      'DATA FIM: ${DateFormat("dd/MM/yyyy HH:mm:ss").format(datafim!)}',
                      align: TextAlign.center),
                  PaddedText('LOCAL: ${historico.local} ',
                      align: TextAlign.center),
                  PaddedText('REGRA: ${historico.regraEstacionamento}',
                      align: TextAlign.center),
                  PaddedText('AUTENTIFICAÇÃO: ${historico.chaveAutenticacao}',
                      align: TextAlign.center),
                ],
              ),
            );
          }

          // Calcula o total de itens nesta página
          int totalPagina = historicos.length;

          // Adiciona o total desta página ao total geral
          totalGeral += totalPagina;

          return [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  border: TableBorder.all(color: PdfColors.black),
                  children: rows,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Total pagina: $totalPagina.",
                  ),
                ),
                if (isLastPage) // Exibe o total geral apenas na última página
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Total geral: $totalGeral",
                    ),
                  ),
              ],
            )
          ];
        },
      ),
    );
  }

  // Adiciona páginas com os históricos em lotes, garantindo que cada página tenha um número limitado de itens
  const maxItemsPerPage = 4;
  for (int i = 0; i < historicos.length; i += maxItemsPerPage) {
    int endIndex = i + maxItemsPerPage;
    if (endIndex > historicos.length) {
      endIndex = historicos.length;
    }
    bool isLastPage =
        endIndex == historicos.length; // Verifica se esta é a última página
    addPageWithHistoricos(historicos.sublist(i, endIndex), isLastPage);
  }

  return pdf.save();
}
