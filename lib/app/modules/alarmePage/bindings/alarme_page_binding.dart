import 'package:get/get.dart';

import '../controllers/alarme_page_controller.dart';

class AlarmePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmePageController>(
      () => AlarmePageController(),
    );
  }
}
