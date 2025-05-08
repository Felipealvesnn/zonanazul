import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';
import 'package:zona_azul/app/utils/getStorages.dart';
import 'package:zona_azul/app/utils/notificationAwesomeNotification.dart';

class NotificacoesGerais {
  static Future<void> notificarEstacionar(var tempoDeEstacionamento) async {
    int alerta = Storagerds.boxvalorAlertaSelecionado
            .read('boxvalorAlertaSelecionado') ??
        600;
    int temp = tempoDeEstacionamento - alerta;

    // Defina um atraso mínimo para a notificação (por exemplo, 1 minuto).
    const int minDelayInSeconds = 60;
    int delayInSeconds = temp < minDelayInSeconds ? minDelayInSeconds : temp;

    CustomNotification notificationBeforeEnd = CustomNotification(
      id: 1,
      title: "Zona azul",
      body: "Seu estacionamento está quase no fim.",
      payload: "Estacionamento",
    );

    CustomNotification notificationTimeIsUp = CustomNotification(
      id: 2,
      title: "Zona azul",
      body: "Tempo de estacionamento acabou.",
      payload: "Estacionamento",
    );

    try {
      if (delayInSeconds != 60) {
        // Schedule notification for when parking is almost ending.
        await NotificationAwesomeNotification.showNotification(
          title: notificationBeforeEnd.title,
          body: notificationBeforeEnd.body,
          interval: delayInSeconds,
          scheduled: true,
        );
      }
      // Schedule notification for when parking time is up.
      await NotificationAwesomeNotification.showNotification(
        title: notificationTimeIsUp.title,
        body: notificationTimeIsUp.body,
        interval: tempoDeEstacionamento,
        locke: true,
        scheduled: true,
      );
    } catch (e) {
      FuncoesParaAjudar.logger.d(e);
    }
  }

  static Future<void> notificarEstacionarWithArlam(int tempoDeEstacionamento) async {
    // tempo em segundos antes de avisar
    final alerta = Storagerds.boxvalorAlertaSelecionado
            .read('boxvalorAlertaSelecionado') ??
        600;
    final temp = tempoDeEstacionamento - alerta;

    const minDelayInSeconds = 60;
    final delayInSeconds = temp < minDelayInSeconds ? minDelayInSeconds : temp;

    final now = DateTime.now();
    final nearEndTime = now.add(Duration(seconds: delayInSeconds.toInt()));
    final endTime = now.add(Duration(seconds: tempoDeEstacionamento));

    // 1) Notificação “quase acabando”
    final alarmNearEnd = AlarmSettings(
      id: 1,
      dateTime: nearEndTime,
      assetAudioPath: 'assets/Oneplus.mp3',
      loopAudio: false,
      vibrate: true,
      notificationSettings: const NotificationSettings(
        title: 'Zona Azul',
        body: 'Seu estacionamento está quase no fim.',
        stopButton: 'Para alarme',
      ),
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: 0.8,
        fadeDuration: Duration(seconds: 5),
        volumeEnforced: true,
      ),
    );

    // 2) Notificação “acabou”
    final alarmTimeIsUp = AlarmSettings(
      id: 2,
      dateTime: endTime,
      assetAudioPath: 'assets/Oneplus.mp3',
      loopAudio: false,
      vibrate: true,
      notificationSettings: const NotificationSettings(
        title: 'Zona Azul',
        body: 'Tempo de estacionamento acabou.',
        stopButton: 'Para alarme',
      ),
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: 0.8,
        fadeDuration: Duration(seconds: 5),
        volumeEnforced: true,
      ),
    );

    try {
      await Alarm.set(alarmSettings: alarmNearEnd);
      await Alarm.set(alarmSettings: alarmTimeIsUp);
    } catch (e) {
      // trate o erro como preferir
      print('Erro ao agendar alarmes: $e');
    }
  }
}

class CustomNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}