import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:zona_azul/app/theme/app_theme.dart';

class RegrasProvider extends GetConnect {
  Future getRegras(String token) async {
    final headers = {"Authorization": 'Bearer ' + token};
    var response = await get(baseUrl + "/RegraEstacionamento/",
        contentType: 'application/json', headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
  
    }
  }
}
