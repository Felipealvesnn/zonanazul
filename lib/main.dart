import 'dart:isolate';
// import 'package:alarm2/alarm2.dart';
import 'package:alarm/alarm.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/theme/tema.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';
import 'package:zona_azul/app/utils/getStorages.dart';
import 'package:zona_azul/app/utils/notificationAwesomeNotification.dart';
import 'app/modules/login_page/controllers/login_page_controller.dart';
import 'app/routes/app_pages.dart';

final playerMain = AudioPlayer();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await IniciarGetStorages();
  await checkAndroidScheduleExactAlarmPermission();
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());

  if (Storagerds.boxTema.read('boxTema') == null) {
    Storagerds.boxTema.write('boxTema', "light");
  }
  LoginPageController loginController = LoginPageController();

  await loginController.testarApi();

  zerarCampos();

  FuncoesParaAjudar.recuperaPosition;

  await NotificationAwesomeNotification.initializeNotification();

  homeController.setTema;
  runApp(
    GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      //  navigatorKey: navigatorKey,
      title: "Zona Azul",
      theme:
          Storagerds.boxTema.read('boxTema') == "dark" ? appTemaDark : appTema,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

Future<void> checkAndroidScheduleExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  print('Schedule exact alarm permission: $status.');
  if (status.isDenied) {
    print('Requesting schedule exact alarm permission...');
    final res = await Permission.scheduleExactAlarm.request();
    print(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
  }
}
