import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';

class DateRangePickerDialogHisto extends StatefulWidget {
  final HistoricoController controller;
  const DateRangePickerDialogHisto({
    super.key,
    required this.controller,
  });

  @override
  _DateRangePickerDialogHistoState createState() =>
      _DateRangePickerDialogHistoState();
}

class _DateRangePickerDialogHistoState
    extends State<DateRangePickerDialogHisto> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // Definindo as datas iniciais como o dia atual
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {}
      },
      child: AlertDialog(
        title: const Text('Selecione o Intervalo de Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Data Inicial:'),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    _selectDate(context, isStartDate: true);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 10),
                      Text(
                        '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Data Final:'),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    _selectDate(context, isStartDate: false);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 10),
                      Text(
                        '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o modal
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.transparent,
              ),
              onPressed: () async {
                // Formate as datas antes de passá-las para a função
                DateFormat formatter = DateFormat("yyyy-MM-dd");
                String formattedStartDate = formatter.format(_startDate);
                String formattedEndDate = formatter.format(_endDate);

                print('Data Inicial: $formattedStartDate');
                print('Data Final: $formattedEndDate');
                widget.controller.isloadingPageHitory.value = true;

                Get.back(closeOverlays: true); // Fecha o modal
                await widget.controller.filtoHistoricoElogmoviment(
                  widget.controller.searchTitle.value,
                  dataInicial: formattedStartDate,
                  dataFinal: formattedEndDate,
                );
                //  Navigator.of(context).pop();
                Get.snackbar(
                  "Filtro",
                  "Filtro aplicado com sucesso!",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                ); // Fecha o modal
                widget.controller.isloadingPageHitory.value = false;

                // Get.back(closeOverlays: true); // Fecha o modal
              },
              child: const Text('Confirmar',
                  style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? pickedDate = await showDatePicker(
      locale: const Locale('pt', 'BR'),
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }
}
