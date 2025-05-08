import 'package:get/get.dart';

class IntroducaoController extends GetxController {
  //TODO: Implement IntroducaoController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
