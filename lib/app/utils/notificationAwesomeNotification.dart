import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zona_azul/app/modules/estacionar/funcoes/funcoes.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';
import 'package:zona_azul/main.dart';

class NotificationAwesomeNotification {
  static const String _soundPath = 'resource://raw/oneplus';

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: false,
          playSound: true,
          criticalAlerts: true,
          enableVibration: true,
          // soundSource: _soundPath,

          // defaultRingtoneType: DefaultRingtoneType.Alarm,
          //  soundSource: 'assets/alarm.mp3',
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Nova notificacao criada');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Schemes: (https: | file: | asset: )
    await playerMain.seek(Duration.zero);
    await playerMain.play();
    debugPrint(' notitifacao recebida no alô');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    await playerMain.stop();
    debugPrint('notifação descartada');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    FuncoesParaAjudar.logger.d('Notificação clicada');
    await playerMain.stop();
    Get.offAllNamed(Routes.HOME);

    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      //  HomeView.navigatorKey!.currentState?.push(
      //     MaterialPageRoute(
      //       builder: (context) => HomeView(),
      //     ),
      //   );
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final bool locke = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          locked: locke,
          id: -1,
          channelKey: 'high_importance_channel',
          title: title,
          body: body,
          // customSound:
          //      'res://raw/oneplus', // Adicione o caminho do arquivo de som aqui
          wakeUpScreen: true,
          actionType: actionType,
          notificationLayout: notificationLayout,
          summary: summary,
          category: category,
          payload: payload,
          // bigPicture: 'assets/flutter.png',
        ),
        actionButtons: actionButtons ??
            [NotificationActionButton(key: 'stop_alarm', label: 'Stop Alarm')],
        schedule: scheduled
            ? NotificationInterval(
                interval: Duration(seconds: interval ?? 0),
                timeZone:
                    await AwesomeNotifications().getLocalTimeZoneIdentifier(),
                preciseAlarm: true,
              )
            : null,
      );
    } catch (e) {
      FuncoesParaAjudar.logger.d(e);
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await AwesomeNotifications().cancelAllSchedules();
      await AwesomeNotifications().cancelAllSchedules();
    } catch (e) {
      FuncoesParaAjudar.logger.d(e);
    }
  }
}
