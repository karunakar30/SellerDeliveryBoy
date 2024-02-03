// ignore_for_file: file_names

import 'package:greenfield_seller/helper/utils/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalAwesomeNotification {
  AwesomeNotifications notification = AwesomeNotifications();
  static FirebaseMessaging messagingInstance = FirebaseMessaging.instance;

  static LocalAwesomeNotification localNotification =
  LocalAwesomeNotification();

  static late StreamSubscription<RemoteMessage> foregroundStream;
  static late StreamSubscription<RemoteMessage> onMessageOpen;

  init(BuildContext context) async {
    await requestPermission();
    await registerListeners(context);
    await notification.initialize(
      'resource://mipmap/logo',
      [
        NotificationChannel(
          channelKey: Constant.notificationChannel,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel',
          playSound: true,
          enableVibration: true,
          importance: NotificationImportance.High,
          ledColor: ColorsRes.appColor,
        )
      ],
      channelGroups: [],
    );

    await listenTap(context);
  }

  @pragma('vm:entry-point')
  listenTap(BuildContext context) {
    try {
      AwesomeNotifications().setListeners(
          onNotificationCreatedMethod: (receivedNotification) async {},
          onActionReceivedMethod: (ReceivedAction event) async {

          });
    } catch (e) {
      rethrow;
    }
  }

  @pragma('vm:entry-point')
  createImageNotification(
      {required RemoteMessage notificationData, required bool isLocked}) async {
    try {
      Map<String, dynamic> data =
      jsonDecode(notificationData.data["data"].toString());
      await notification.createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          color: ColorsRes.appColor,
          title: data["title"],
          locked: isLocked,
          payload: Map.from(notificationData.data),
          autoDismissible: true,
          showWhen: true,
          notificationLayout: NotificationLayout.BigPicture,
          body: data["message"],
          wakeUpScreen: true,
          largeIcon: data["image"],
          bigPicture: data["image"],
          channelKey: Constant.notificationChannel,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @pragma('vm:entry-point')
  createNotification(
      {required RemoteMessage notificationData, required bool isLocked}) async {
    try {
      Map<String, dynamic> data =
      jsonDecode(notificationData.data["data"].toString());

      await notification.createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          color: ColorsRes.appColor,
          title: data["title"],
          locked: isLocked,
          payload: Map.from(notificationData.data),
          autoDismissible: true,
          showWhen: true,
          notificationLayout: NotificationLayout.Default,
          body: data["message"],
          wakeUpScreen: true,
          channelKey: Constant.notificationChannel,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @pragma('vm:entry-point')
  requestPermission() async {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    try {
      Map<String, dynamic> data = jsonDecode(message.data["data"].toString());
      if (data["image"] == "" || data["image"] == null) {
        localNotification.createNotification(
            isLocked: false, notificationData: message);
      } else {
        localNotification.createImageNotification(
            isLocked: false, notificationData: message);
      }
    } catch (e) {
    }
  }

  @pragma('vm:entry-point')
  static foregroundNotificationHandler() async {
    foregroundStream =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          try {
            Map<String, dynamic> data = jsonDecode(message.data["data"].toString());
            if (data["image"] == "" || data["image"] == null) {
              localNotification.createNotification(
                  isLocked: false, notificationData: message);
            } else {
              localNotification.createImageNotification(
                  isLocked: false, notificationData: message);
            }
          } catch (e) {
          }
        });
  }

  @pragma('vm:entry-point')
  static terminatedStateNotificationHandler() {
    FirebaseMessaging.instance.getInitialMessage().then(
          (RemoteMessage? message) {
        if (message == null) {
          return;
        }

        Map<String, dynamic> data = jsonDecode(message.data["data"].toString());
        if (data["image"] == "" || data["image"] == null) {
          localNotification.createNotification(
              isLocked: false, notificationData: message);
        } else {
          localNotification.createImageNotification(
              isLocked: false, notificationData: message);
        }
      },
    );
  }

  @pragma('vm:entry-point')
  static registerListeners(context) async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    await foregroundNotificationHandler();
    await terminatedStateNotificationHandler();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      if (message.notification != null) {
        LocalAwesomeNotification.onBackgroundMessageHandler(message);
      }
    });
  }

  @pragma('vm:entry-point')
  static disposeListeners() {
    onMessageOpen.cancel();
    foregroundStream.cancel();
  }
}
