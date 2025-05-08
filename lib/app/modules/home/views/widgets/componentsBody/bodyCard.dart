import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:slide_countdown/slide_countdown.dart';

class BodyCard extends StatelessWidget {
  final bool isEstacionado;
  final String placa;
  final String regra;
  final String dataInicio;
  final String dataFim;
  final String localEstacionado;
  final String localchaveAutenticacao;
  final int startContador;

  const BodyCard({
    super.key,
    required this.isEstacionado,
    required this.placa,
    required this.regra,
    required this.dataInicio,
    required this.dataFim,
    required this.localEstacionado,
    required this.localchaveAutenticacao,
    this.startContador = 0,
  });

  static const _iconColor = Color(0xFF88B19F);
  static const _labelStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: Colors.black87,
  );
  static const _valueStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isEstacionado,
     // replacement: const Center(child: CircularProgressIndicator()),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        opacity: isEstacionado ? 1 : 0,
        child: Card(
          margin: const EdgeInsets.all(12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Ionicons.car_outline, "Placa", placa),
                _countUpRow(Ionicons.time_outline, "Passado", startContador),
                _infoRow(Ionicons.document_text_outline, "Regra", regra),
                _infoRow(Ionicons.calendar_outline, "Início", dataInicio),
                _infoRow(Ionicons.calendar_outline, "Término", dataFim),
                _infoRow(Icons.location_on, "Local", localEstacionado),
                if (localchaveAutenticacao.isNotEmpty)
                  const AuthFieldExpandable(
                      token: 'bfb5e64e-c985-499b-a7e2-10a4b3d28bbc'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Get.theme.primaryColor),
          const SizedBox(width: 12),
          Text("$label: ", style: _labelStyle),
          Expanded(child: Text(value, style: _valueStyle)),
        ],
      ),
    );
  }

  Widget _countUpRow(IconData icon, String label, int seconds) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Get.theme.primaryColor),
          const SizedBox(width: 12),
          Text("$label: ", style: _labelStyle),
          SlideCountdown(
            countUp: true,
            slideDirection: SlideDirection.none,
            decoration: const BoxDecoration(color: Colors.transparent),
            replacement: const Text("00:00", style: _valueStyle),
            style: _valueStyle,
            separatorStyle: _valueStyle,
            streamDuration: StreamDuration(
              config: StreamDurationConfig(
                isCountUp: true,
                countUpConfig: CountUpConfig(
                  initialDuration: Duration(seconds: seconds),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthFieldExpandable extends StatefulWidget {
  final String token;

  const AuthFieldExpandable({super.key, required this.token});

  @override
  State<AuthFieldExpandable> createState() => _AuthFieldExpandableState();
}

class _AuthFieldExpandableState extends State<AuthFieldExpandable> {
  bool mostrarToken = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
             Icon(Icons.vpn_key, color: Get.theme.primaryColor),
            const SizedBox(width: 8),
            const Text(
              'Autenticação:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  mostrarToken = !mostrarToken;
                });
              },
              child: Text(
                mostrarToken ? 'Ocultar' : 'Mostrar',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (mostrarToken) ...[
          const SizedBox(height: 6),
          Row(

            children: [
           SizedBox(width: 16),

              Expanded(
                child: AutoSizeText(
                  //maxLines: 1,
                  widget.token,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
