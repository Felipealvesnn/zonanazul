import 'package:get/get.dart';

import '../controllers/intro2_controller.dart';

class Intro2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Intro2Controller>(
      () => Intro2Controller(),
    );
  }
}
