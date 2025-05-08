// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';

class TextBold extends Text {
  String conteudo;
  TextBold(this.conteudo, {super.key}) : super('');

  @override
  Widget build(BuildContext context) {
    return Text(conteudo, style: const TextStyle(fontWeight: FontWeight.bold));
  }
}
