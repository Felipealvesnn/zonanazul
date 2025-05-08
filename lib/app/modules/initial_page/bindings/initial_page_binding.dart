import 'package:get/get.dart';

import '../controllers/initial_page_controller.dart';

class InitialPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InitialPageController>(
      () => InitialPageController(),
      //Get.lazyPut<InitialRepository>(() => LoginRepository());
      //Get.lazyPut<LoginProvider>(() => LoginProvider());
    );
  }
}
