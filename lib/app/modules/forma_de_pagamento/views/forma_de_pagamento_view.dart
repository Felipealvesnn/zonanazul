import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forma_de_pagamento_controller.dart';

class FormaDePagamentoView extends GetView<FormaDePagamentoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FormaDePagamentoView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'FormaDePagamentoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
