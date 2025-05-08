import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/alarme_page_controller.dart';

class AlarmePageView extends GetView<AlarmePageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AlarmePageView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AlarmePageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
