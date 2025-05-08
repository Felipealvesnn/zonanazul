import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:slide_countdown/slide_countdown.dart';

class CircularProgressIndicatorNamao extends StatefulWidget {
  final Duration duracao;
  final String? texto;

  const CircularProgressIndicatorNamao({
    super.key,
    required this.duracao,
    this.texto,
  });

  @override
  _CountdownCircularState createState() => _CountdownCircularState();
}

class _CountdownCircularState extends State<CircularProgressIndicatorNamao> {
  late Timer _timer;
  double _percentRemaining = 1.0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    final int totalMilliseconds = widget.duracao.inMilliseconds;
    int millisecondsRemaining = totalMilliseconds;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      millisecondsRemaining -= 100;
      if (millisecondsRemaining < 0) {
        _timer.cancel();
        setState(() {
          _percentRemaining = 0.0;
        });
      } else {
        setState(() {
          _percentRemaining = millisecondsRemaining / totalMilliseconds;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    // Adiciona o widget de texto se 'texto' não for nulo
    // if (widget.texto != null) {
    //   children.add(
    //     Positioned(
    //       top: 10,
    //       child: Text(widget.texto!),
    //     ),
    //   );
    // }
    children.addAll([
      SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          semanticsLabel: widget.texto,
          value: _percentRemaining,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
          strokeWidth: 8.0,
        ),
      ),
      SlideCountdown(
        decoration: const BoxDecoration(color: Colors.transparent),
        slideDirection: SlideDirection.none,
        duration: widget.duracao,
        separator: ":",
        style:
            const TextStyle(color: Colors.black, overflow: TextOverflow.clip),
        separatorStyle: const TextStyle(color: Colors.black),
      )
    ]);

    return Stack(
      alignment: Alignment.center,
      children: children,
    );
  }
}
