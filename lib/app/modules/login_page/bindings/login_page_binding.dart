import 'package:get/get.dart';
import 'package:zona_azul/app/data/provider/login_provider.dart';
import 'package:zona_azul/app/data/repository/login_repository.dart';

import '../controllers/login_page_controller.dart';

class LoginPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginPageController>(() => LoginPageController());
    Get.lazyPut<LoginRepository>(() => LoginRepository());
    Get.lazyPut<LoginProvider>(() => LoginProvider());
  }
}
