import 'package:get/get.dart';
import 'package:zona_azul/app/data/global/constants.dart';

class ContaProvider extends GetConnect {
  Future<Map<String, dynamic>> retornaConta(String cpf, String token) async {
    final headers = {"Authorization": 'Bearer ' + token};
    var response = await get(baseUrl + "/Conta/$cpf",
        contentType: 'application/json', headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body[0];
    }
  }
}
