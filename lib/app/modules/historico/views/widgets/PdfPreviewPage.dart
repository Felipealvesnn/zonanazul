import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:zona_azul/app/data/models/historicoLog.dart';

import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/modules/historico/views/widgets/Listpdfexport.dart';
import 'package:zona_azul/app/modules/historico/views/widgets/makePdfLog.dart';
import 'package:zona_azul/app/modules/historico/views/widgets/pdfexport.dart';

class PdfPreviewPage extends StatelessWidget {
  final List<HistoricoEstacionamento>? historicos;
  final HistoricoEstacionamento? historico;
  final LogPagamento? logPagamento;

  const PdfPreviewPage({
    super.key,
    this.historicos,
    this.historico,
    this.logPagamento,
  }) : assert(historicos != null || historico != null || logPagamento != null,
            'Pelo menos um dos parâmetros historicos ou historico deve ser fornecido.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF', style: TextStyle(color: Colors.white)),
      ),
      body: PdfPreview(
        canDebug: false,
        build: (context) {
          if (historicos != null) {
            return listmakePdf(historicos!);
          } else if (historico != null) {
            return makePdf(historico!);
          }else{
            return makePdfLog(logPagamento!);
          }
        },
      ),
    );
  }
}


// class PdfPreviewPage extends StatelessWidget {
//   final HistoricoEstacionamento historico;

//   PdfPreviewPage({required this.historico});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Uint8List>(
//       future: makePdf(historico),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return PdfViewerDocument(bytes: snapshot.data!);
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Erro ao carregar PDF: ${snapshot.error}'),
//           );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
// }
